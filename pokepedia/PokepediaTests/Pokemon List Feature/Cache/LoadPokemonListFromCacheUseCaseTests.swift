//
//  LoadPokemonListFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/31/23.
//

import XCTest
import Pokepedia

final class LoadPokemonListFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSut()
        
        _ = try? sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieval])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSut()
        let retrieveError = anyNSError()
        store.stubRetrieve(with: retrieveError)
        
        expect(sut, toCompleteWith: .failure(retrieveError))
    }
    
    func test_load_deliversNoListOnEmptyCache() throws {
        let (sut, store) = makeSut()
        store.stubEmptyRetrieve()
        
        expect(sut, toCompleteWith: .success(nil))
    }
    
    func test_load_deliversCachedListOnNonExpiredCache() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: nonExpiredTimestamp)
        
        expect(sut, toCompleteWith: .success(list.model))
    }
    
    func test_load_deliversNoCachedListOnCacheExpiration() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expirationDateTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expirationDateTimestamp)
        
        expect(sut, toCompleteWith: .success(nil))
    }
    
    func test_load_deliversNoListOnExpiredCache() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expiredTimestamp)
        
        expect(sut, toCompleteWith: .success(nil))
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
    
    private func expect(
        _ sut: LocalPokemonListLoader,
        toCompleteWith expectedResult: Result<PokemonList?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.load() }
        switch (receivedResult, expectedResult) {
        case let (.success(receivedImages), .success(expectedImages)):
            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
