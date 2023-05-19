//
//  LocalLoaderTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/18/23.
//

import XCTest

typealias TimestampValidation = (_ timestamp: Date, _ against: Date) -> Bool

struct StoreRetrieval {
    let timestamp: Date
}

final class LocalLoader {
    struct EmptyCache: Error {}
    
    private let store: StoreMock
    private let validation: TimestampValidation
    private let current: () -> Date
    
    init(
        store: StoreMock,
        validation: @escaping TimestampValidation,
        current: @escaping () -> Date
    ) {
        self.store = store
        self.validation = validation
        self.current = current
    }
    
    func load(for key: String) throws {
        let result = try store.retrieve(for: key)
        guard let result = result else { throw EmptyCache() }
        if !validation(result.timestamp, current()) {
            store.delete(for: key)
            throw NSError()
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
        
        try? sut.load(for: key)
        
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
        let (sut, _, key) = makeSutWith(expiredCache: true)
        
        XCTAssertThrowsError(
            try sut.load(for: key)
        )
    }
    
    func test_load_deletesCacheOnExpiredTimestamp() {
        let (sut, store, key) = makeSutWith(expiredCache: true)
        
        try? sut.load(for: key)
        
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
    
    // MARK: - Helpers
    
    private func makeSutWith(
        expiredCache: Bool,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalLoader, StoreMock, String) {
        let key = anyKey()
        let current = Date()
        let timestamp = anyPreviousDate()
        let expiredValidation = validation(
            expired: expiredCache,
            current: current,
            timestamp: timestamp
        )
        let (sut, store) = makeSut(
            file: file,
            line: line,
            current: current,
            validate: expiredValidation
        )
        store.stubRetrieve(result: .success(.init(timestamp: timestamp)), for: key)
        return (sut, store, key)
    }
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line,
        current: Date = .init(),
        validate: @escaping TimestampValidation = { _, _ in false }
    ) -> (LocalLoader, StoreMock) {
        let store = StoreMock()
        let sut = LocalLoader(
            store: store,
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
    
    private func validation(
        file: StaticString = #filePath,
        line: UInt = #line,
        expired: Bool,
        current: Date,
        timestamp: Date
    ) -> TimestampValidation {
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

final class StoreMock {
    struct Unexpected: Error {}
    enum Message: Equatable {
        case retrieve(String)
        case delete(String)
    }
    
    var messages: [Message] = []
    var retrieveStubs = [String: Result<StoreRetrieval?, Error>]()
    
    func retrieve(for key: String) throws -> StoreRetrieval? {
        messages.append(.retrieve(key))
        if let stub = retrieveStubs[key] {
            return try stub.get()
        }
        throw Unexpected()
    }
    
    func delete(for key: String) {
        messages.append(.delete(key))
    }
    
    func stubRetrieve(result: Result<StoreRetrieval?, Error>, for key: String) {
        retrieveStubs[key] = result
    }
}
