//
//  CoreDataLocalPokemonListStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/2/23.
//

import XCTest
import Pokepedia

final class CoreDataLocalPokemonListStore: LocalPokemonListStore {
    func retrieve() throws -> Pokepedia.CachedPokemonList? {
        nil
    }
    
    func delete() throws {
        
    }
    
    func insert(local: Pokepedia.LocalPokemonList, timestamp: Date) throws {
        
    }
}

final class CoreDataPokemonListLocalStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSut()
        
        expect(sut, toRetrieve: .success(nil))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSut()
        
        expect(sut, toRetrieveTwice: .success(nil))
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> LocalPokemonListStore {
        let sut = CoreDataLocalPokemonListStore()
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
