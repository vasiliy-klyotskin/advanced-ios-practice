//
//  PokemonListStoreSpecs.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import Foundation

protocol PokemonListStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()
    func test_insert_deliversNoErrorOnEmptyCache()
    func test_insert_deliversNoErrorOnNonEmptyCache()
    func test_insert_overridesPreviouslyInsertedCacheValues()
    func test_delete_deliversNoErrorOnEmptyCache()
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_deliversNoErrorOnNonEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()
}

protocol FailableRetrievePokemonListStoreSpecs: PokemonListStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertPokemonListStoreSpecs: PokemonListStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeletePokemonListStoreSpecs: PokemonListStoreSpecs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailbalePokemonListStoreSpecs = FailableRetrievePokemonListStoreSpecs & FailableInsertPokemonListStoreSpecs & FailableDeletePokemonListStoreSpecs


import XCTest
import Pokepedia

extension PokemonListStoreSpecs where Self: XCTestCase {
    func expect(
        _ sut: PokemonListStore,
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
    
    func expect(
        _ sut: PokemonListStore,
        toRetrieveTwice expectedResult: Result<CachedPokemonList?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
}

extension PokemonListStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: .success(nil), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieveTwice: .success(nil), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let list = pokemonList().local
        let timestamp = Date()
        try? sut.insert(local: list, timestamp: timestamp)
        
        expect(sut, toRetrieve: .success(CachedPokemonList(local: list, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let list = pokemonList().local
        let timestamp = Date()
        try? sut.insert(local: list, timestamp: timestamp)
        
        expect(sut, toRetrieveTwice: .success(.init(local: list, timestamp: timestamp)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertNoThrow(try sut.insert(local: pokemonList().local, timestamp: anyDate()), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())
        
        XCTAssertNoThrow(try sut.insert(local: pokemonList().local, timestamp: anyDate()), file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(
        sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())
        
        let latestList = pokemonList().local
        let latestTimestamp = Date()
        try? sut.insert(local: latestList, timestamp: latestTimestamp)
        
        expect(sut, toRetrieve: .success(.init(local: latestList, timestamp: latestTimestamp)), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertNoThrow(try sut.delete(), file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        try? sut.delete()
        
        expect(sut, toRetrieveTwice: .success(nil), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())
        
        XCTAssertNoThrow(try sut.delete(), file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())
        
        try? sut.delete()
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}

extension FailableRetrievePokemonListStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}

extension FailableInsertPokemonListStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(
            try sut.insert(
                local: pokemonList().local,
                timestamp: anyDate()
            ),
            file: file,
            line: line
        )
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(
        _ sut: PokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())

        expect(sut, toRetrieve: .success(nil), file: file, line: line)
    }
}
