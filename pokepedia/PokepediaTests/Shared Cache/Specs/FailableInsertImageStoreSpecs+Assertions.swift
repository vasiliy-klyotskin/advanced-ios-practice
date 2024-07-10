//
//  FailableInsertImageStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/6/23.
//

import XCTest
import Pokepedia

extension FailableInsertImageStoreSpecs where Self: XCTestCase {
    func assertThatInsertImageDataDeliversFailureOnInsertionError(
        _ sut: ImageStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try sut.insertImage(data: Data("any data".utf8), for: anyURL()), file: file, line: line)
    }
}
