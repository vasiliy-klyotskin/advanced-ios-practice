//
//  LocalLoaderTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/18/23.
//

import XCTest

struct StoreRetrieval<Local> {
    let local: Local
    let timestamp: Date
}

final class LocalLoader<Local, Model> {
    public typealias Validation = (_ timestamp: Date, _ against: Date) -> Bool
    public typealias Mapping = (Local) -> Model
    
    struct EmptyCache: Error {}
    
    private let store: StoreMock
    private let mapping: Mapping
    private let validation: Validation
    private let current: () -> Date
    
    init(
        store: StoreMock,
        mapping: @escaping Mapping,
        validation: @escaping Validation,
        current: @escaping () -> Date
    ) {
        self.store = store
        self.validation = validation
        self.current = current
        self.mapping = mapping
    }
    
    func load(for key: String) throws -> Model {
        let result = try store.retrieve(for: key)
        guard let result = result else { throw EmptyCache() }
        if !validation(result.timestamp, current()) {
            store.delete(for: key)
            throw NSError()
        } else {
            return mapping(result.local as! Local)
        }
    }
}

final class LocalLoaderTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.messages.count, 0)
    }
    
    func test_load_retrievesDataForKey() {
        let (sut, store) = makeSut()
        let key = anyKey()
        
        _ = try? sut.load(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_load_deliversErrorOnRetrievalError() {
        let (sut, store) = makeSut()
        let key = anyKey()
        store.stubRetrieve(result: .failure(anyNSError()), for: key)
        
        XCTAssertThrowsError(
            try sut.load(for: key)
        )
    }
    
    func test_load_deliversErrorOnExpiredTimestamp() {
        let (sut, _, key) = makeSutWith(cacheExpired: true)
        
        XCTAssertThrowsError(
            try sut.load(for: key)
        )
    }
    
    func test_load_deletesCacheOnExpiredTimestamp() {
        let (sut, store, key) = makeSutWith(cacheExpired: true)
        
        _ = try? sut.load(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key), .delete(key)])
    }
    
    func test_load_deliversErrorOnEmptyCache() {
        let (sut, store) = makeSut()
        let key = anyKey()
        
        store.stubRetrieve(result: .success(nil), for: key)
        
        XCTAssertThrowsError(
            try sut.load(for: key)
        )
    }
    
    func test_load_deliversModelOnNotExpiredCache() throws {
        let expectedModel = ModelStub()
        let (sut, _, key) = makeSutWith(
            cacheExpired: false,
            expectedModel: expectedModel
        )
        
        let actualModel = try sut.load(for: key)
    
        XCTAssertEqual(actualModel, expectedModel)
    }
    
    // MARK: - Helpers
    
    typealias Loader = LocalLoader<LocalStub, ModelStub>
    
    private func makeSutWith(
        cacheExpired: Bool,
        expectedModel: ModelStub? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (Loader, StoreMock, String) {
        let key = anyKey()
        let current = Date()
        let timestamp = anyPreviousDate()
        let local = LocalStub()
        let expiredValidation = validationMock(
            expired: expectedModel == nil,
            current: current,
            timestamp: timestamp
        )
        let (sut, store) = makeSut(mapping:
            mappingMock(local: local, mapped: expectedModel ?? .init()),
            current: current,
            validate: expiredValidation
        )
        let storeRetrieval: StoreRetrieval = .init(local: local, timestamp: timestamp)
        store.stubRetrieve(result: .success(.init(storeRetrieval)), for: key)
        return (sut, store, key)
    }
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line,
        mapping: ((LocalStub) -> ModelStub)? = nil,
        current: Date = .init(),
        validate: @escaping Loader.Validation = { _, _ in false }
    ) -> (Loader, StoreMock) {
        let store = StoreMock()
        let sut = LocalLoader(
            store: store,
            mapping: mapping ?? { _ in .init() },
            validation: validate,
            current: { current }
        )
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    private func anyKey() -> String {
        anyId()
    }
    
    private func mappingMock(
        file: StaticString = #filePath,
        line: UInt = #line,
        local: LocalStub,
        mapped: ModelStub
    ) -> Loader.Mapping {
        { actualLocal in
            XCTAssertEqual(
                actualLocal,
                local,
                "Mapping should be called with right local",
                file: file,
                line: line
            )
            return mapped
        }
    }
    
    private func validationMock(
        file: StaticString = #filePath,
        line: UInt = #line,
        expired: Bool,
        current: Date,
        timestamp: Date
    ) -> Loader.Validation {
        { actualTimestamp, actualCurrent in
            XCTAssertEqual(
                actualTimestamp,
                timestamp,
                "Validation should be called with right timestamp",
                file: file,
                line: line
            )
            XCTAssertEqual(
                actualCurrent,
                current,
                "Validation should be called with right current date",
                file: file,
                line: line
            )
            return !expired
        }
    }
    
    private func anyPreviousDate() -> Date {
        adding(days: -1, to: Date())
    }
    
    private func adding(days: Int, to date: Date) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: date)!
    }
}

struct LocalStub: Equatable {
    let id: UUID = .init()
}
struct ModelStub: Equatable {
    let id: UUID = .init()
}

final class StoreMock {
    struct Unexpected: Error {}
    enum Message: Equatable {
        case retrieve(String)
        case delete(String)
    }
    
    var messages: [Message] = []
    var retrieveStubs = [String: Result<StoreRetrieval<LocalStub>?, Error>]()
    
    func retrieve(for key: String) throws -> StoreRetrieval<LocalStub>? {
        messages.append(.retrieve(key))
        if let stub = retrieveStubs[key] {
            return try stub.get()
        }
        throw Unexpected()
    }
    
    func delete(for key: String) {
        messages.append(.delete(key))
    }
    
    func stubRetrieve(result: Result<StoreRetrieval<LocalStub>?, Error>, for key: String) {
        retrieveStubs[key] = result
    }
}
