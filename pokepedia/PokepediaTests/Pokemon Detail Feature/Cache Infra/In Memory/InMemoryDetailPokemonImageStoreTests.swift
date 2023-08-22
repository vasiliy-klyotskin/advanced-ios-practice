//
//  InMemoryDetailPokemonImageStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation
import Pokepedia
import XCTest

final class InMemoryDetailPokemonImageStoreTests: XCTestCase, ImageStoreSpecs {
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
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> InMemoryDetailPokemonStore {
        let sut = InMemoryDetailPokemonStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
