//
//  CachePokemonListImageUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/4/23.
//

import XCTest
import Pokepedia

final class CachePokemonListImageUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (LocalPokemonListImageLoader, PokemonListImageStoreSpy) {
        let store = PokemonListImageStoreSpy()
        let sut = LocalPokemonListImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
