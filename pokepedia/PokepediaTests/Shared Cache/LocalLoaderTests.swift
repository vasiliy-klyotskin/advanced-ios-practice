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
        let (_, store, _) = makeSut()
        
        XCTAssertEqual(store.messages.count, 0)
    }
    
    func test_load_retrievesDataForKey() {
        let (sut, store, key) = makeSut()
        
        _ = try? sut.load(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_load_deliversErrorOnRetrievalError() {
        let (sut, store, key) = makeSut()
        store.stubRetrieve(result: .failure(anyNSError()), for: key)
        
        XCTAssertThrowsError(
            try sut.load(for: key)
        )
    }
    
    func test_load_deliversErrorOnExpiredTimestamp() {
        let (sut, _, key) = makeSut(cacheExpired: true)
        
        XCTAssertThrowsError(
            try sut.load(for: key)
        )
    }
    
    func test_load_hasNoSideEffectsOnExpiredCache() {
        let (sut, store, key) = makeSut(cacheExpired: true)
        
        _ = try? sut.load(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_load_deliversErrorOnEmptyCache() {
        let (sut, store, key) = makeSut()
        
        store.stubRetrieve(result: .success(nil), for: key)
        
        XCTAssertThrowsError(
            try sut.load(for: key)
        )
    }
    
    func test_load_deliversModelOnNotExpiredCache() throws {
        let expectedModel = ModelStub()
        let (sut, _, key) = makeSut(
            cacheExpired: false,
            expectedModel: expectedModel
        )
        
        let actualModel = try sut.load(for: key)
    
        XCTAssertEqual(actualModel, expectedModel)
    }
    
    // MARK: - Helpers
    
    typealias Loader = LocalLoader<LocalStub, ModelStub>
    typealias Key = String
    
    private func makeSut(
        cacheExpired: Bool = true,
        expectedModel: ModelStub? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (Loader, StoreMock, Key) {
        let key = anyKey()
        let timestamp = anyDate()
        let local = LocalStub()
        let expiredValidation = validationStub(
            expired: expectedModel == nil,
            timestamp: timestamp
        )
        let (sut, store) = makeBaseSut(
            file: file,
            line: line,
            mapping: mappingStub(local: local, mapped: expectedModel ?? .init()),
            validate: expiredValidation
        )
        let storeRetrieval: LocalRetrieval = .init(local: local, timestamp: timestamp)
        store.stubRetrieve(result: .success(.init(storeRetrieval)), for: key)
        return (sut, store, key)
    }
    
    private func makeBaseSut(
        file: StaticString = #filePath,
        line: UInt = #line,
        mapping: ((LocalStub) -> ModelStub)? = nil,
        validate: @escaping Loader.Validation = { _ in false }
    ) -> (Loader, StoreMock) {
        let store = StoreMock()
        let sut = LocalLoader(
            store: store,
            mapping: mapping ?? { _ in .init() },
            validation: validate
        )
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    private func mappingStub(
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
}
