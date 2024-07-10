//
//  CachePokemonListUseCaseTests.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/1/23.
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
        
        try? sut.save(pokemonList().model)
        
        XCTAssertEqual(store.receivedMessages, [.deletion])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let list = pokemonList()
        let (sut, store) = makeSut(currentDate: { timestamp })
        store.stubDeletionWithSuccess()
        
        try? sut.save(list.model)
        
        XCTAssertEqual(store.receivedMessages, [.deletion, .insertion(timestamp: timestamp, local: list.local)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSut()
        let deletionError = anyNSError()
        store.stubDeletion(with: deletionError)
        
        expect(sut, toCompleteWithError: deletionError)
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSut()
        let insertionError = anyNSError()
        store.stubDeletionWithSuccess()
        store.stubInsertion(with: insertionError)
        
        expect(sut, toCompleteWithError: insertionError)
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSut()
        store.stubDeletionWithSuccess()
        store.stubInsertionWithSuccess()
        
        expect(sut, toCompleteWithError: nil)
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalPokemonListLoader, PokemonListStoreSpy) {
        let store = PokemonListStoreSpy()
        let sut = LocalPokemonListLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalPokemonListLoader,
        toCompleteWithError expectedError: NSError?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            try sut.save(pokemonList().model)
        } catch {
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}
