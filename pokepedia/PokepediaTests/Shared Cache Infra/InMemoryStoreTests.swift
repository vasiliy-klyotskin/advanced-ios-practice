//
//  InMemoryStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

final class InMemoryStore<Local> {
    typealias Timestamp = Date
    
    private var stored: (local: Local, timestamp: Timestamp)?
    
    func retrieve(for key: String) -> StoreRetrieval<Local>? {
        stored.map { .init(local: $0.local, timestamp: $0.timestamp) }
    }
    
    func insert(_ data: LocalInserting<Local>, for key: String) {
        stored = (data.local, data.timestamp)
    }
}

final class InMemoryStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let (sut, key) = makeSut()
        
        let cache = sut.retrieve(for: key)
        
        XCTAssertNil(cache)
    }
    
    func test_retrieve_hasNoSideEffects() {
        let (sut, key) = makeSut()
        _ = sut.retrieve(for: key)
        
        let cache = sut.retrieve(for: key)
        
        XCTAssertNil(cache)
    }
    
    func test_retrieve_deliversCacheOnNotEmpty() {
        let (sut, key) = makeSut()
        let timestamp = Date()
        let data = anyData()
        sut.insert(.init(timestamp: timestamp, local: data), for: key)
        
        let cache = sut.retrieve(for: key)
        
        XCTAssertEqual(cache?.local, data)
    }
    
    // MARK: - Helpers
    
    typealias Store = InMemoryStore<Data>
    typealias Key = String
    
    private func makeSut() -> (Store, Key) {
        let sut = Store()
        let key = anyKey()
        trackForMemoryLeaks(sut)
        return (sut, key)
    }
}
