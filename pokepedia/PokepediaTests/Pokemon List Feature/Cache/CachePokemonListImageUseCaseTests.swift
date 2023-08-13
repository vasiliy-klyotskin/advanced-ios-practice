//
//  CachePokemonListImageUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/4/23.
//

import XCTest
import Pokepedia

final class CachePokemonListImageUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSut()
        let url = anyURL()
        let data = Data("any data".utf8)
        
        try? sut.save(data, for: url)
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, url: url)])
    }
    
    func test_saveImageDataFromURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSut()
        let insertionError = anyNSError()
        store.stubInsertionWith(error: insertionError)
        
        expect(sut, toCompleteWith: .failure(insertionError))
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() {
        let (sut, store) = makeSut()
        store.stubInsertionWithSuccess()
        
        expect(sut, toCompleteWith: .success(()))
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (LocalPokemonListImageLoader, PokemonListImageStoreSpy) {
        let store = PokemonListImageStoreSpy()
        let sut = LocalPokemonListImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalPokemonListImageLoader,
        toCompleteWith expectedResult: Result<Void, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.save(Data("any data".utf8), for: anyURL()) }
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
        case (.failure(let receivedError as NSError),
              .failure(let expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
