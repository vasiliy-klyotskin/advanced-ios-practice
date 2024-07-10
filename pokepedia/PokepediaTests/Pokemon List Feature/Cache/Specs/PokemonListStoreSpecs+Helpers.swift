//
//  PokemonListStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/6/23.
//

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
