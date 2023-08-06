//
//  FailableInsertPokemonListImageStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import XCTest
import Pokepedia

extension FailableInsertPokemonListImageStoreSpecs where Self: XCTestCase {
    func assertThatInsertImageDataDeliversFailureOnInsertionError(
        _ sut: PokemonListImageStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try sut.insertImage(data: anyData(), for: anyURL()), file: file, line: line)
    }
}
