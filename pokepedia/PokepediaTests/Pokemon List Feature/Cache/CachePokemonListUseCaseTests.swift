//
//  CachePokemonListUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/1/23.
//

import XCTest
import Pokepedia

final class CachePokemonListUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSut()
        store.stubDeletion(with: anyNSError())
        
        sut.save(pokemonList().model)
        
        XCTAssertEqual(store.receivedMessages, [.deletion])
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        currentDate: () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalPokemonListLoader, PokemonListStoreMock) {
        let store = PokemonListStoreMock()
        let sut = LocalPokemonListLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
