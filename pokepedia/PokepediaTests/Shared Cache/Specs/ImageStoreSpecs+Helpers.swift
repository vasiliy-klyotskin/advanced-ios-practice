//
//  ImageStoreSpecs+Helpers.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import XCTest
import Pokepedia

extension ImageStoreSpecs where Self: XCTestCase {
    func expect(
        _ sut: ImageStore,
        toCompleteRetrievalWith expectedResult: Result<Data?, Error>,
        for url: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let receivedResult = Result { try sut.retrieveImage(for: url) }
        switch (receivedResult, expectedResult) {
        case (.failure, .failure):
            break
        case let (.success( receivedData), .success(expectedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
