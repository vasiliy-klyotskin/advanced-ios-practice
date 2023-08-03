//
//  CoreDataLocalPokemonListStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/2/23.
//

import XCTest
import Pokepedia

final class CoreDataPokemonListLocalStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSut()
        
        expect(sut, toRetrieve: .success(nil))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSut()
        
        expect(sut, toRetrieveTwice: .success(nil))
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSut()
        let list = pokemonList().local
        let timestamp = Date()
        try? sut.insert(local: list, timestamp: timestamp)
        
        expect(sut, toRetrieve: .success(CachedPokemonList(local: list, timestamp: timestamp)))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSut()
        let list = pokemonList().local
        let timestamp = Date()
        try? sut.insert(local: list, timestamp: timestamp)
        
        
        expect(sut, toRetrieveTwice: .success(.init(local: list, timestamp: timestamp)))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSut()
        
        XCTAssertNoThrow(try sut.insert(local: pokemonList().local, timestamp: anyDate()))
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSut()
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())
        
        XCTAssertNoThrow(try sut.insert(local: pokemonList().local, timestamp: anyDate()))
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSut()
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())
        
        let latestList = pokemonList().local
        let latestTimestamp = Date()
        try? sut.insert(local: latestList, timestamp: latestTimestamp)
        
        expect(sut, toRetrieve: .success(.init(local: latestList, timestamp: latestTimestamp)))
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSut()
        
        XCTAssertNoThrow(try sut.delete())
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSut()
        
        try? sut.delete()
        
        expect(sut, toRetrieveTwice: .success(nil))
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> LocalPokemonListStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = CoreDataLocalPokemonListStore(storeUrl: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(
        _ sut: LocalPokemonListStore,
        toRetrieveTwice expectedResult: Result<CachedPokemonList?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(
        _ sut: LocalPokemonListStore,
        toRetrieve expectedResult: Result<CachedPokemonList?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let retrievedResult = Result { try sut.retrieve() }
        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
             (.failure, .failure):
            break
            
        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved.local, expected.local, file: file, line: line)
            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
