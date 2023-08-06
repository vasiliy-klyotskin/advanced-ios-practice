//
//  InMemoryPokemonListImageStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import XCTest
import Pokepedia

final class InMemoryPokemonListImageStoreTests: XCTestCase, PokemonListImageStoreSpecs {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSut()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenEmpty(sut)
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSut()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(sut)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSut()
        
        assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(sut)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSut()
        
        assertThatRetrieveImageDataDeliversLastInsertedValue(sut)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> InMemoryPokemonListStore {
        let sut = InMemoryPokemonListStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
