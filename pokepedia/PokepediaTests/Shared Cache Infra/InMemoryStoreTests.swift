//
//  InMemoryStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

final class InMemoryStore<Local> {
    typealias Key = String
    typealias Timestamp = Date
    typealias Cache = (local: Local, timestamp: Timestamp)
    
    private var stored = [Key: Cache]()
    
    func retrieve(for key: String) -> StoreRetrieval<Local>? {
        stored[key].map { .init(local: $0.local, timestamp: $0.timestamp) }
    }
    
    func insert(_ data: LocalInserting<Local>, for key: String) {
        stored[key] = (data.local, data.timestamp)
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
        let (insertion, timestamp, data) = anyInsertion()
        sut.insert(insertion, for: key)
        
        let cache = sut.retrieve(for: key)
        
        XCTAssertEqual(cache?.local, data)
        XCTAssertEqual(cache?.timestamp, timestamp)
    }
    
    func test_retrieve_doesNotDeliverCacheOnDifferentKey() {
        let (sut, key) = makeSut()
        let (insertion, _, _) = anyInsertion()
        let differentKey = anyKey()
        sut.insert(insertion, for: key)
        
        let cache = sut.retrieve(for: differentKey)
        
        XCTAssertNil(cache)
    }
    
    // MARK: - Helpers
    
    typealias Local = Data
    typealias Store = InMemoryStore<Local>
    typealias Key = String
    
    private func makeSut() -> (Store, Key) {
        let sut = Store()
        let key = anyKey()
        trackForMemoryLeaks(sut)
        return (sut, key)
    }
    
    private func anyInsertion() -> (LocalInserting<Local>, Date, Local) {
        let timestamp = Date()
        let data = anyData()
        return (.init(timestamp: timestamp, local: data), timestamp, data)
    }
}
