//
//  ImageStoreSpecs.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/6/23.
//

import XCTest
import Pokepedia

protocol ImageStoreSpecs {
    func test_retrieveImageData_deliversNotFoundWhenEmpty()
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch()
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL()
    func test_retrieveImageData_deliversLastInsertedValue()
}

protocol FailableRetrieveImageStoreSpecs: ImageStoreSpecs {
    func test_retrieveImageData_deliversFailureOnRetrievalError()
}

protocol FailableInsertImageStoreSpecs: ImageStoreSpecs {
    func test_insertImageData_deliversFailureOnInsertionError()
}

typealias FailableImageStoreSpecs = FailableRetrieveImageStoreSpecs & FailableInsertImageStoreSpecs
