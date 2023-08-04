//
//  CoreDataPokemonListImageDataStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/4/23.
//

import XCTest
import Pokepedia
import CoreData

final class CoreDataPokemonListImageStoreTests: XCTestCase {
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSut()
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSut()
        let url = URL(string: "http://a-url.com")!
        let nonMatchingURL = URL(string: "http://another-url.com")!
        
        insert(anyData(), for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSut()
        let storedData = anyData()
        let matchingURL = URL(string: "http://a-url.com")!
        
        insert(storedData, for: matchingURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedData), for: matchingURL)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSut()
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)
        let url = anyURL()
        
        insert(firstStoredData, for: url, into: sut)
        insert(lastStoredData, for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: url)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> CoreDataPokemonListStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = CoreDataPokemonListStore(storeUrl: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func notFound() -> Result<Data?, Error> {
        return .success(.none)
    }
    
    private func found(_ data: Data) -> Result<Data?, Error> {
        return .success(data)
    }
    
    private func expect(
        _ sut: PokemonListImageStore,
        toCompleteRetrievalWith expectedResult: Result<Data?, Error>,
        for url: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.retrieveImage(for: url) }
        switch (receivedResult, expectedResult) {
        case let (.success( receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
    
    private func insert(
        _ data: Data, for url: URL, into sut: CoreDataPokemonListStore, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let localItem = LocalPokemonListItem(id: "any id", name: "any name", imageUrl: url, physicalType: .init(color: "any color", name: "any name"), specialType: nil)
            try sut.insert(local: [localItem], timestamp: anyDate())
            try sut.insertImage(data: data, for: url)
        } catch {
            XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
        }
    }
}
