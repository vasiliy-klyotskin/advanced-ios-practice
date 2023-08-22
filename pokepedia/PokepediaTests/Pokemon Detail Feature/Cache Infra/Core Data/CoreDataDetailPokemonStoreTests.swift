//
//  CoreDataDetailPokemonStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import XCTest
import Pokepedia

final class CoreDataDetailPokemonStoreTests: XCTestCase, DetailPokemonStoreSpecs {
    func test_retrieveForId_returnsEmptyOnEmptyCache() {
        let sut = { self.makeSut() }
        
        assertThat_retrieveForId_returnsEmptyOnEmptyCache(sut: sut)
    }
    
    func test_retrieveForValidation_returnsEmptyOnEmptyCache() throws {
        let sut = makeSut()
        
        try assertThat_retrieveForValidation_returnsEmptyOnEmptyCache(sut: sut)
    }
    
    func test_retrieveForId_returnsCacheForIdWhenCacheIsNotEmpty() {
        let sut = makeSut()
        
        assertThat_retrieveForId_returnsCacheForIdWhenCacheIsNotEmpty(sut: sut)
    }
    
    func test_retrieveForValidation_returnsValidationRetrievalWhenCacheIsNotEmpty() throws {
        let sut = makeSut()
        
        try assertThat_retrieveForValidation_returnsValidationRetrievalWhenCacheIsNotEmpty(sut: sut)
    }
    
    func test_deleteForId_deletesCacheForParticularId() {
        let sut = makeSut()
        
        assertThat_deleteForId_deletesCacheForParticularId(sut: sut)
    }
    
    func test_deleteForId_affectsValidationRetrieval() throws {
        let sut = makeSut()
        
        try assertThat_deleteForId_affectsValidationRetrieval(sut: sut)
    }
    
    func test_deleteAll_removesAllPokemons() {
        let sut = makeSut()
        
        assertThat_deleteAll_removesAllPokemons(sut: sut)
    }
    
    func test_deleteAll_cauesesValidationRetrievalsAreEmpty() throws {
        let sut = makeSut()
        
        try assertThat_DeleteAll_cauesesValidationRetrievalsAreEmpty(sut: sut)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> DetailPokemonStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataDetailPokemonStore(storeUrl: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
