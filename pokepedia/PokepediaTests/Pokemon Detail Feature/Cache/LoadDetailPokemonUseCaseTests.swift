//
//  LoadDetailPokemonUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/21/23.
//

import XCTest

final class DetailPokemonStoreSpy {
    
}

final class LocalDetailPokemonLoader {
    
}

final class LoadDetailPokemonUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
//    
//    func test_load_requestsCacheRetrieval() {
//        let (sut, store) = makeSut()
//        
//        _ = try? sut.load()
//        
//        XCTAssertEqual(store.receivedMessages, [.retrieval])
//    }
//    
//    func test_load_failsOnRetrievalError() {
//        let (sut, store) = makeSut()
//        let retrieveError = anyNSError()
//        store.stubRetrieve(with: retrieveError)
//        
//        expect(sut, toCompleteWith: .failure(retrieveError))
//    }
//    
//    func test_load_deliversNoListOnEmptyCache() {
//        let (sut, store) = makeSut()
//        store.stubEmptyRetrieve()
//        
//        expect(sut, toCompleteWith: .failure(anyNSError()))
//    }
//    
//    func test_load_deliversCachedListOnNonExpiredCache() {
//        let list = pokemonList()
//        let fixedCurrentDate = Date()
//        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
//        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
//        store.stubRetrieveWith(local: list.local, timestamp: nonExpiredTimestamp)
//        
//        expect(sut, toCompleteWith: .success(list.model))
//    }
//    
//    func test_load_deliversNoCachedListOnCacheExpiration() {
//        let list = pokemonList()
//        let fixedCurrentDate = Date()
//        let expirationDateTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
//        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
//        store.stubRetrieveWith(local: list.local, timestamp: expirationDateTimestamp)
//        
//        expect(sut, toCompleteWith: .failure(anyNSError()))
//    }
//    
//    func test_load_deliversNoListOnExpiredCache() {
//        let list = pokemonList()
//        let fixedCurrentDate = Date()
//        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
//        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
//        store.stubRetrieveWith(local: list.local, timestamp: expiredTimestamp)
//        
//        expect(sut, toCompleteWith: .failure(anyNSError()))
//}
    
    // MARK: - Helpers
    
    private func makeSut(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LocalDetailPokemonLoader, PokemonListStoreSpy) {
        let store = PokemonListStoreSpy()
        let sut = LocalDetailPokemonLoader()
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
//    private func expect(
//        _ sut: LocalPokemonListLoader,
//        toCompleteWith expectedResult: Result<PokemonList?, Error>,
//        file: StaticString = #filePath,
//        line: UInt = #line
//    ) {
//        let receivedResult = Result { try sut.load() }
//        switch (receivedResult, expectedResult) {
//        case let (.success(receivedImages), .success(expectedImages)):
//            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
//        case (.failure, .failure):
//            break
//        default:
//            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
//        }
//    }
}
