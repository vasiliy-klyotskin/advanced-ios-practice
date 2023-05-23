//
//  InMemoryStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

final class InMemoryStore {
    func retrieve(for key: String) -> StoreRetrieval<Any>? {
        nil
    }
}

final class InMemoryStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let (sut, key) = makeSut()
        
        let cache = sut.retrieve(for: key)
        
        XCTAssertNil(cache)
    }
    
    // MARK: - Helpers
    
    typealias Store = InMemoryStore
    typealias Key = String
    
    private func makeSut() -> (Store, Key) {
        let sut = InMemoryStore()
        let key = anyKey()
        trackForMemoryLeaks(sut)
        return (sut, key)
    }
}
