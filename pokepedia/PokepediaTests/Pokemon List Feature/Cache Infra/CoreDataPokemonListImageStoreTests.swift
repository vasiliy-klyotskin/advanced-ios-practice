//
//  CoreDataPokemonListImageDataStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/4/23.
//

import XCTest
import Pokepedia
import CoreData

final class CoreDataPokemonListImageStoreTests: XCTestCase, FailablePokemonListImageStoreSpecs {
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
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoreDataPokemonListStore, imageUrl: URL) {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataPokemonListStore(storeUrl: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        let imageUrl = anyURL()
        insertItem(for: imageUrl, into: sut)
        return (sut, imageUrl)
    }
    
    private func insertItem(
        for url: URL,
        into sut: CoreDataPokemonListStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            try sut.insert(local: anyLocalList(for: url), timestamp: anyDate())
        } catch {
            XCTFail("Failed to insert list item with error \(error)", file: file, line: line)
        }
    }
    
    private func anyLocalList(for url: URL) -> LocalPokemonList {
        [LocalPokemonListItem(id: "any id", name: "any name", imageUrl: url, physicalType: .init(color: "any color", name: "any name"), specialType: nil)]
    }
}
