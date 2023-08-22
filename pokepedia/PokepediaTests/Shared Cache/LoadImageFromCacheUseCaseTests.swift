//
//  LoadImageFromCacheUseCaseTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/3/23.
//

import XCTest
import Pokepedia

final class LoadImageFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSut()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_load_requestsStoredDataForURL() {
        let (sut, store) = makeSut()
        let url = anyURL()
        
        _ = try? sut.loadImageData(from: url)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    func test_loadImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSut()
        let retrieveError = anyNSError()
        store.stubRetrieveWith(error: retrieveError)
        
        expect(sut, toCompleteWith: .failure(retrieveError))
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSut()
        store.stubRetrieveWithEmpty()
        
        expect(sut, toCompleteWith: .failure(LocalImageLoader.LoadError.notFound))
    }
    
    func test_loadImageDataFromURL_deliversStoredDataOnFoundData() {
        let (sut, store) = makeSut()
        let foundData = Data("any data".utf8)
        store.stubRetrievalWith(data: foundData)
        
        expect(sut, toCompleteWith: .success(foundData))
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (LocalImageLoader, ImageStoreSpy) {
        let store = ImageStoreSpy()
        let sut = LocalImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalImageLoader,
        toCompleteWith expectedResult: Result<Data, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.loadImageData(from: anyURL()) }
        switch (receivedResult, expectedResult) {
        case let (.success(receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        case (.failure(let receivedError as NSError),
              .failure(let expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
