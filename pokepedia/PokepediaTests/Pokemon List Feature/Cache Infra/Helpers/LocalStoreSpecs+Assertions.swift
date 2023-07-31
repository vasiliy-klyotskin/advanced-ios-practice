//
//  LocalStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/29/23.
//

import XCTest
import Pokepedia

extension LocalStoreSpecs where Self: XCTestCase {
    func assertThat<SUT: LocalStore>(_ sut: SUT) -> LocalStoreAssertions<SUT> where SUT.Local == Data {
        .init(sut: sut)
    }
}

struct LocalStoreAssertions<Store: LocalStore> where Store.Local == Data {
    let sut: Store
    
    func retrieveDeliversEmptyOnEmptyCache(
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let cache = sut.retrieve(for: anyKey())
        
        XCTAssertNil(cache, file: file, line: line)
    }
    
    func retrieveHasNoSideEffects(file: StaticString = #filePath, line: UInt = #line) {
        let key = anyKey()
        _ = sut.retrieve(for: key)
        
        let cache = sut.retrieve(for: key)
        
        XCTAssertNil(cache, file: file, line: line)
    }
    
    func retrieveDeliversCacheOnNotEmpty(file: StaticString = #filePath, line: UInt = #line) {
        let key = anyKey()
        let insertion = anyInsertion()
        sut.insert(insertion, for: key)
        
        let retrieval = sut.retrieve(for: key)
        
        assert(retrieval, equals: insertion, file: file, line: line)
    }
    
    func retrieveDeliversDifferentCacheOnDifferentKey(file: StaticString = #filePath, line: UInt = #line) {
        let key1 = anyKey()
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
    
    func insertOverridesPreviouslyInsertedCache(file: StaticString = #filePath, line: UInt = #line) {
        let key = anyKey()
        let insertion = anyInsertion()
        let lastInsertion = anyInsertion()
        sut.insert(insertion, for: key)
        sut.insert(lastInsertion, for: key)
        
        let retrieval = sut.retrieve(for: key)
        
        assert(retrieval, equals: lastInsertion)
    }
    
    func deleteHasNoSideEffectsOnEmptyCache(file: StaticString = #filePath, line: UInt = #line) {
        let key = anyKey()

        sut.delete(for: key)
        let retrieval = sut.retrieve(for: key)
        
        XCTAssertNil(retrieval)
    }
    
    func deleteDeletesPreviouslyInsertedCache(file: StaticString = #filePath, line: UInt = #line) {
        let key = anyKey()
        let insertion = anyInsertion()
        sut.insert(insertion, for: key)

        sut.delete(for: key)
        let retrieval = sut.retrieve(for: key)
        
        XCTAssertNil(retrieval)
    }
    
    func deleteDeletesDifferentCacheOnDifferentKey(file: StaticString = #filePath, line: UInt = #line) {
        let key1 = anyKey()
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
    
    private func assert(
        _ retrieval: LocalRetrieval<Store.Local>?,
        equals insertion: LocalInserting<Store.Local>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(insertion.local, retrieval?.local, file: file, line: line)
        XCTAssertEqual(insertion.timestamp, retrieval?.timestamp, file: file, line: line)
    }
    
    private func anyInsertion() -> LocalInserting<Store.Local> {
        .init(timestamp: Date(), local: anyData())
    }
}
