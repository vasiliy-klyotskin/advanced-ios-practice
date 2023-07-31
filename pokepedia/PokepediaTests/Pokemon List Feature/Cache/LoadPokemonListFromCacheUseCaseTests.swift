//
//  LoadPokemonListFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import XCTest

final class LocalPokemonListLoader {
    
}

final class LoadPokemonListFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (LocalPokemonListLoader, PokemonListStoreMock) {
        let mock = PokemonListStoreMock()
        let sut = LocalPokemonListLoader()
        trackForMemoryLeaks(mock, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, mock)
    }
}

final class PokemonListStoreMock {
    var receivedMessages: [Any] = []
}
