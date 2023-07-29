//
//  InMemoryStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/22/23.
//

import XCTest
import Pokepedia

final class InMemoryStoreTests: XCTestCase, LocalStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSut()

        assertThat(sut).retrieveDeliversEmptyOnEmptyCache()
    }
    
    func test_retrieve_hasNoSideEffects() {
        let sut = makeSut()

        assertThat(sut).retrieveHasNoSideEffects()
    }
    
    func test_retrieve_deliversCacheOnNotEmpty() {
        let sut = makeSut()

        assertThat(sut).retrieveDeliversCacheOnNotEmpty()
    }
    
    func test_insert_overridesPreviouslyInsertedCache() {
        let sut = makeSut()

        assertThat(sut).insertOverridesPreviouslyInsertedCache()
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSut()

        assertThat(sut).deleteHasNoSideEffectsOnEmptyCache()
    }
    
    func test_delete_deletesPreviouslyInsertedCache() {
        let sut = makeSut()

        assertThat(sut).deleteDeletesPreviouslyInsertedCache()
    }
    
    func test_retrieve_deliversDifferentCacheOnDifferentKey() {
        let sut = makeSut()

        assertThat(sut).retrieveDeliversDifferentCacheOnDifferentKey()
    }
    
    func test_delete_deletesDifferentCacheOnDifferentKey() {
        let sut = makeSut()

        assertThat(sut).deleteDeletesDifferentCacheOnDifferentKey()
    }
    
    // MARK: - Helpers
    
    private func makeSut() -> InMemoryStore<Data> {
        let sut = InMemoryStore<Data>()
        trackForMemoryLeaks(sut)
        return sut
    }
}
