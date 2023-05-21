//
//  LocalValidatorTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/21/23.
//

import XCTest
import Pokepedia

protocol LocalValidatorStore {
    func retrieve(for key: String) -> Date?
}

final class LocalValidator {
    typealias Validation = (Date) -> Bool
    
    private let validation: Validation
    private let store: LocalValidatorStore
    
    init(store: LocalValidatorStore, validation: @escaping Validation) {
        self.validation = validation
        self.store = store
    }
    
    func validate(for key: String) {
        store.retrieve(for: key)
    }
}

final class LocalValidatorTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.messages.isEmpty)
    }
    
    func test_validate_doesNotDeleteOnRetrievalErrorForKey() {
        let key = anyKey()
        let (sut, store) = makeSut()
        store.stubRetrieve(result: .failure(anyNSError()), for: key)
        
        sut.validate(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_validate_doesNotDeleteOnEmptyCacheForKey() {
        let timestamp = Date()
        let key = anyKey()
        let (sut, store) = makeSut()
        
        store.stubRetrieve(result: .success(nil), for: key)
        sut.validate(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    func test_validate_doesNotDeleteOnNotExpiredCacheForKey() {
        let timestamp = Date()
        let key = anyKey()
        let (sut, store) = makeSut(validation: validationStub(isValid: true, timestamp: timestamp))
        
        sut.validate(for: key)
        
        XCTAssertEqual(store.messages, [.retrieve(key)])
    }
    
    // MARK: - Helpers
    
    typealias Validator = LocalValidator
    
    private func makeSut(
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
