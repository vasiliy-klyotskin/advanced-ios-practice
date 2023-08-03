//
//  LoadPokemonListImageFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/3/23.
//

import XCTest
import Pokepedia

final class PokemonListimageLoader {
    
}

final class LoadPokemonListImageFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (PokemonListimageLoader, PokemonListImageStoreSpy) {
        let store = PokemonListImageStoreSpy()
        let sut = PokemonListimageLoader()
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}

final class PokemonListImageStoreSpy {
    var receivedMessages: [Any] = []
}
