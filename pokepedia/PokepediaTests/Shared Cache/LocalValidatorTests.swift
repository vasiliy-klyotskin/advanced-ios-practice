//
//  LocalValidatorTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/21/23.
//

import XCTest
import Pokepedia

final class LocalValidator {
    
}

final class LocalValidatorTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    typealias Validator = LocalValidator
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (Validator, StoreMock) {
        let store = StoreMock()
        let sut = Validator()
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
}
