//
//  LocalSaverTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/20/23.
//

import XCTest
import Pokepedia

final class LocalSaver {
    
}

final class LocalSaverTests: XCTestCase {
    func test_init_hasNoSideEffects() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.messages.isEmpty)
    }
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalSaver, StoreMock) {
        let store = StoreMock()
        let sut = LocalSaver()
        trackForMemoryLeaks(store)
        trackForMemoryLeaks(sut)
        return (sut, store)
    }
}
