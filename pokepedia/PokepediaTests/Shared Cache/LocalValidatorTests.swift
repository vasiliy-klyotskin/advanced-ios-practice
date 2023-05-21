//
//  LocalValidatorTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/21/23.
//

import XCTest
import Pokepedia

final class LocalValidatorTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store, _) = makeSut()
        
        XCTAssertTrue(store.messages.isEmpty)
    }
    
    func test_validate_doesNotDeleteOnRetrievalErrorForKey() {
        let (sut, store, key) = makeSut()
        store.stubRetrieve(result: .failure(anyNSError()), for: key)
        
        sut.validate(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_validate_doesNotDeleteOnEmptyCacheForKey() {
        let (sut, store, key) = makeSut()
        store.stubRetrieve(result: .success(nil), for: key)
        
        sut.validate(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_validate_doesNotDeleteOnNotExpiredCacheForKey() {
        let (sut, store, key) = makeSut(expired: false)
        
        sut.validate(for: key)

        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_validate_deletesOnExpiredCacheForKey() {
        let (sut, store, key) = makeSut(expired: true)
        
        sut.validate(for: key)

        XCTAssertEqual(store.messages, [.retrieve(key), .delete(key)])
    }
    
    // MARK: - Helpers
    
    typealias Validator = LocalValidator
    
    private func makeSut(
        expired: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (Validator, StoreMock, String) {
        let timestamp = Date()
        let key = anyKey()
        let (sut, store) = makeBaseSut(
            file: file,
            line: line,
            validation: validationStub(isValid: !expired, timestamp: timestamp)
        )
        store.stubRetrieve(result: .success(.init(local: .init(), timestamp: timestamp)), for: key)
        return (sut, store, key)
    }
    
    private func makeBaseSut(
        file: StaticString = #filePath,
        line: UInt = #line,
        validation: @escaping Validator.Validation = { _ in true }
    ) -> (Validator, StoreMock) {
        let store = StoreMock()
        let sut = Validator(store: store, validation: validation)
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
    
    private func anyKey() -> String {
        anyId()
    }
    
    private func validationStub(
        isValid: Bool,
        timestamp: Date,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Validator.Validation {
        { actualTimestamp in
            XCTAssertEqual(
                timestamp,
                actualTimestamp,
                "Validation should be called with correct timestamp",
                file: file,
                line: line
            )
            return isValid
        }
    }
}
