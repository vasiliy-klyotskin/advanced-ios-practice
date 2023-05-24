//
//  InMemoryStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

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
        let insertion = anyInsertion()
        sut.insert(insertion, for: key)
        
        let retrieval = sut.retrieve(for: key)
        
        assert(retrieval, equals: insertion)
    }
    
    func test_insert_overridesPreviouslyInsertedCache() {
        let (sut, key) = makeSut()
        let insertion = anyInsertion()
        let lastInsertion = anyInsertion()
        sut.insert(insertion, for: key)
        sut.insert(lastInsertion, for: key)
        
        let retrieval = sut.retrieve(for: key)
        
        assert(retrieval, equals: lastInsertion)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let (sut, key) = makeSut()

        sut.delete(for: key)
        let retrieval = sut.retrieve(for: key)
        
        XCTAssertNil(retrieval)
    }
    
    func test_delete_deletesPreviouslyInsertedCache() {
        let (sut, key) = makeSut()
        let insertion = anyInsertion()
        sut.insert(insertion, for: key)

        sut.delete(for: key)
        let retrieval = sut.retrieve(for: key)
        
        XCTAssertNil(retrieval)
    }
    
    func test_retrieve_deliversDifferentCacheOnDifferentKey() {
        let (sut, key1) = makeSut()
        let key2 = anyKey()
        let insertion1 = anyInsertion()
        let insertion2 = anyInsertion()
        sut.insert(insertion1, for: key1)
        sut.insert(insertion2, for: key2)

        let retrieval1 = sut.retrieve(for: key1)
        let retrieval2 = sut.retrieve(for: key2)

        assert(retrieval1, equals: insertion1)
        assert(retrieval2, equals: insertion2)
    }
    
    func test_delete_deleteDifferentCacheOnDifferentKey() {
        let (sut, key1) = makeSut()
        let key2 = anyKey()
        let insertion1 = anyInsertion()
        let insertion2 = anyInsertion()
        sut.insert(insertion1, for: key1)
        sut.insert(insertion2, for: key2)
        
        sut.delete(for: key2)
        let retrieval1 = sut.retrieve(for: key1)
        let retrieval2 = sut.retrieve(for: key2)
        
        assert(retrieval1, equals: insertion1)
        XCTAssertNil(retrieval2)
        
        sut.delete(for: key1)
        let retrieval1_ = sut.retrieve(for: key1)
        let retrieval2_ = sut.retrieve(for: key2)
        
        XCTAssertNil(retrieval1_)
        XCTAssertNil(retrieval2_)
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
    
    private func assert(
        _ retrieval: LocalRetrieval<Local>?,
        equals insertion: LocalInserting<Local>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(insertion.local, retrieval?.local, file: file, line: line)
        XCTAssertEqual(insertion.timestamp, retrieval?.timestamp, file: file, line: line)
    }
    
    private func anyInsertion() -> LocalInserting<Local> {
        .init(timestamp: Date(), local: anyData())
    }
}
