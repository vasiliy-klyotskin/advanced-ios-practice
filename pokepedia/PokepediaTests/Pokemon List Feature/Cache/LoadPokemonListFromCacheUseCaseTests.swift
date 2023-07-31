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
        store.stubRetrieve(with: anyNSError())
        
        XCTAssertThrowsError(try sut.load())
    }
    
    func test_load_deliversNoListOnEmptyCache() throws {
        let (sut, store) = makeSut()
        store.stubEmptyRetrieve()
        
        let list = try sut.load()
        
        XCTAssertEqual(list, nil)
    }
    
    func test_load_deliversCachedListOnNonExpiredCache() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: nonExpiredTimestamp)
        
        let result = try sut.load()
        
        XCTAssertEqual(result, list.model)
    }
    
    func test_load_deliversNoCachedListOnCacheExpiration() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expirationDateTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expirationDateTimestamp)
        
        let result = try sut.load()
        
        XCTAssertEqual(result, nil)
    }
    
    func test_load_deliversNoListOnExpiredCache() throws {
        let list = pokemonList()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSut(currentDate: { fixedCurrentDate })
        store.stubRetrieveWith(local: list.local, timestamp: expiredTimestamp)
        
        let result = try sut.load()
        
        XCTAssertEqual(result, nil)
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
    
    private func pokemonList() -> (local: LocalPokemonList, model: PokemonList) {
        let url = anyURL()
        let local: LocalPokemonList = [
            .init(
                id: "an id",
                name: "a name",
                imageUrl: url,
                physicalType: .init(
                    color: "physical color",
                    name: "name of physical color"
                ),
                specialType: .init(
                    color: "special colorr",
                    name: "name of special color"
                )
            )
        ]
        let model: PokemonList = [
            .init(
                id: "an id",
                name: "a name",
                imageUrl: url,
                physicalType: .init(
                    color: "physical color",
                    name: "name of physical color"
                ),
                specialType: .init(
                    color: "special colorr",
                    name: "name of special color"
                )
            )
        ]
        return (local, model)
    }
}
