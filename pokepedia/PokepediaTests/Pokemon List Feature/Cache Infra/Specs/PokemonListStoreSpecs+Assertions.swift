//
//  PokemonListStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import XCTest
import Pokepedia

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
