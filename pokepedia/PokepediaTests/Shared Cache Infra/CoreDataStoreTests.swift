//
//  CoreDataStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/29/23.
//

import Pokepedia
import XCTest

final class CoreDataStoreTests: XCTestCase, LocalStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSut()
        
        assertThat(sut).retrieveDeliversEmptyOnEmptyCache()
    }
    
    func test_retrieve_hasNoSideEffects() {
        let sut = makeSut()
        
        assertThat(sut).retrieveHasNoSideEffects()
    }
    
    func test_retrieve_deliversCacheOnNotEmpty() {
        
    }
    
    func test_insert_overridesPreviouslyInsertedCache() {
        
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        
    }
    
    func test_delete_deletesPreviouslyInsertedCache() {
        
    }
    
    func test_retrieve_deliversDifferentCacheOnDifferentKey() {
        
    }
    
    func test_delete_deletesDifferentCacheOnDifferentKey() {
        
    }
    
    // MARK: - Helpers
    
    private func makeSut() -> CoreDataStore {
        .init()
    }
}
