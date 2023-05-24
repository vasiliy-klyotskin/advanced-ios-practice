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
    
    func delete(for key: String) {
        stored = [:]
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
    
//    func test_retrieve_doesNotDeliverCacheOnDifferentKey() {
//        let (sut, key1) = makeSut()
//        let key2 = anyKey()
//        let (insertion1, timestamp1, data1) = anyInsertion()
//        let (insertion2, timestamp2, data2) = anyInsertion()
//        sut.insert(insertion1, for: key1)
//        sut.insert(insertion2, for: key2)
//
//        let cache1 = sut.retrieve(for: key1)
//        let cache2 = sut.retrieve(for: key2)
//
//        XCTAssertEqual(cache1?.local, data1)
//        XCTAssertEqual(cache1?.timestamp, timestamp1)
//        XCTAssertEqual(cache2?.local, data2)
//        XCTAssertEqual(cache2?.timestamp, timestamp2)
//    }
    
    func test_insert_overridesPreviouslyInsertedCache() {
        let (sut, key) = makeSut()
        let (insertion, _, _) = anyInsertion()
        let (lastInsertion, lastTimestamp, lastData) = anyInsertion()
        sut.insert(insertion, for: key)
        sut.insert(lastInsertion, for: key)
        
        let cache = sut.retrieve(for: key)
        
        XCTAssertEqual(cache?.local, lastData)
        XCTAssertEqual(cache?.timestamp, lastTimestamp)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let (sut, key) = makeSut()

        sut.delete(for: key)
        let cache = sut.retrieve(for: key)
        
        XCTAssertNil(cache)
    }
    
    func test_delete_deletesPreviouslyInsertedCache() {
        let (sut, key) = makeSut()
        let (insertion, _, _) = anyInsertion()
        sut.insert(insertion, for: key)

        sut.delete(for: key)
        let cache = sut.retrieve(for: key)
        
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
