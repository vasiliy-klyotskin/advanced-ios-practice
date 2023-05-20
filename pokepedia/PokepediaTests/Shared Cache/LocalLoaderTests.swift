//
//  LocalLoaderTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/18/23.
//

import XCTest
import Pokepedia

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
    
    func test_load_hasNoSideEffectsOnExpiredCache() {
        let (sut, store, key) = makeSutWith(cacheExpired: true)
        
        _ = try? sut.load(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
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
    
    typealias Loader = LocalLoader<LocalStub, ModelStub, StoreMock>
    
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
        let (sut, store) = makeSut(
            file: file,
            line: line,
            mapping: mappingMock(local: local, mapped: expectedModel ?? .init()),
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
