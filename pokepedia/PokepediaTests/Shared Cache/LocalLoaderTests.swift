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
    
    func load() throws {
        let result = try store.retrieve()
        if !validation(result.timestamp, current()) {
            store.delete()
            throw NSError()
        }
    }
}

final class LocalLoaderTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.messages.count, 0)
    }
    
    func test_load_retrievesData() {
        let (sut, store) = makeSut()
        
        try? sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve])
    }
    
    func test_load_deliversErrorOnRetrievalError() {
        let (sut, store) = makeSut()
        store.stubRetrieve(result: .failure(anyNSError()))
        
        XCTAssertThrowsError(
            try sut.load()
        )
    }
    
    func test_load_deliversErrorOnExpiredTimestamp() {
        let current = Date()
        let timestamp = anyPreviousDate()
        let expiredValidation = validation(
            expired: true,
            current: current,
            timestamp: timestamp
        )
        let (sut, store) = makeSut(current: current, validate: expiredValidation)
        store.stubRetrieve(result: .success(.init(timestamp: timestamp)))
        
        XCTAssertThrowsError(
            try sut.load()
        )
    }
    
    func test_load_deletesCacheOnExpiredTimestamp() {
        let current = Date()
        let timestamp = anyPreviousDate()
        let expiredValidation = validation(
            expired: true,
            current: current,
            timestamp: timestamp
        )
        let (sut, store) = makeSut(current: current, validate: expiredValidation)
        store.stubRetrieve(result: .success(.init(timestamp: timestamp)))
        
        try? sut.load()
        
        XCTAssertEqual(store.messages, [.retrieve, .delete])
    }
    
    // MARK: - Helpers
    
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
    enum Message {
        case retrieve
        case delete
    }
    
    var messages: [Message] = []
    var retrieveStub: Result<StoreRetrieval, Error>?
    
    func retrieve() throws -> StoreRetrieval {
        messages.append(.retrieve)
        if let stub = retrieveStub {
            return try stub.get()
        }
        throw Unexpected()
    }
    
    func delete() {
        messages.append(.delete)
    }
    
    func stubRetrieve(result: Result<StoreRetrieval, Error>) {
        retrieveStub = result
    }
}
