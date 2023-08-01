//
//  ValidatePokemonListCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/1/23.
//

import XCTest
import Pokepedia

final class ValidatePokemonListCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSut()
        store.stubRetrieve(with: anyNSError())

        sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval, .deletion])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSut()
        store.stubEmptyRetrieve()
        
        sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval])
    }
    
    func test_validateCache_doesNotDeleteNonExpiredCache() {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: nonExpiredTimestamp)
        
        sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval])
    }
    
    func test_validateCache_deletesCacheOnExpiration() {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expirationDateTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expirationDateTimestamp)
        
        sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval, .deletion])
    }
    
    func test_validateCache_deletesExpiredCache() {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expiredTimestamp)
        
        sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval, .deletion])
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalPokemonListLoader, PokemonListStoreMock) {
        let store = PokemonListStoreMock()
        let sut = LocalPokemonListLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
