//
//  FailableRetrievePokemonListImageStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import XCTest
import Pokepedia

extension FailableRetrievePokemonListImageStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveImageDataDeliversFailureOnRetrievalError(
        _ sut: PokemonListImageStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toCompleteRetrievalWith: .failure(anyNSError()), for: anyURL(), file: file, line: line)
    }
}
