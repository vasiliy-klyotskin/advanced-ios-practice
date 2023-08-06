//
//  FailableInsertPokemonListStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import XCTest
import Pokepedia

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
