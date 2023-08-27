//
//  CoreDataDetailPokemonImageStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import XCTest
import Pokepedia
import CoreData

final class CoreDataDetailPokemonImageStoreTests: XCTestCase, FailableImageStoreSpecs {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let (sut, _) = makeSut()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenEmpty(sut)
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let (sut, imageUrl) = makeSut()
        
        assertThatRetrieveImageDataDeliversNotFoundWhenStoredDataURLDoesNotMatch(sut, imageUrl: imageUrl)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let (sut, imageUrl) = makeSut()
        
        assertThatRetrieveImageDataDeliversFoundDataWhenThereIsAStoredImageDataMatchingURL(sut, imageUrl: imageUrl)
    }

    func test_retrieveImageData_deliversLastInsertedValue() {
        let (sut, imageUrl) = makeSut()

        assertThatRetrieveImageDataDeliversLastInsertedValue(sut, imageUrl: imageUrl)
    }

    func test_retrieveImageData_deliversFailureOnRetrievalError() {
        let (sut, _) = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        
        assertThatRetrieveImageDataDeliversFailureOnRetrievalError(sut)
    }

    func test_insertImageData_deliversFailureOnInsertionError() {
        let (sut, _) = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()

        assertThatInsertImageDataDeliversFailureOnInsertionError(sut)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoreDataDetailPokemonStore, imageUrl: URL) {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataDetailPokemonStore(storeUrl: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        let imageUrl = anyURL()
        insertItem(for: imageUrl, into: sut)
        return (sut, imageUrl)
    }
    
    private func insertItem(
        for url: URL,
        into sut: CoreDataDetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let anyId = 0
        sut.insert(.init(timestamp: anyDate(), local: anyLocalDetail(for: url)), for: anyId)
    }
    
    private func anyLocalDetail(for url: URL) -> LocalDetailPokemon {
        .init(info: .init(imageUrl: url, id: 0, name: "name", genus: "genus", flavorText: "flavor text"), abilities: [])
    }
}
