//
//  CoreDataLocalPokemonListStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/2/23.
//

import XCTest
import Pokepedia

final class CoreDataPokemonListLocalStoreTests: XCTestCase, FailbalePokemonListStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSut()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSut()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSut()

        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSut()

        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(sut)
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSut()
        
        assertThatInsertDeliversNoErrorOnEmptyCache(sut)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSut()

        assertThatInsertDeliversNoErrorOnNonEmptyCache(sut)
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSut()

        assertThatInsertOverridesPreviouslyInsertedCacheValues(sut: sut)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSut()
        
        assertThatDeleteDeliversNoErrorOnEmptyCache(sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSut()
        
        assertThatDeleteHasNoSideEffectsOnEmptyCache(sut)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSut()

        assertThatDeleteDeliversNoErrorOnNonEmptyCache(sut)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSut()

        assertThatDeleteEmptiesPreviouslyInsertedCache(sut)
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let sut = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        
        assertThatRetrieveDeliversFailureOnRetrievalError(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let sut = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        
        assertThatRetrieveHasNoSideEffectsOnFailure(sut)
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let sut = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        
        assertThatInsertDeliversErrorOnInsertionError(sut)
    }
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        let sut = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        
        assertThatInsertHasNoSideEffectsOnInsertionError(sut)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let sut = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        try? sut.insert(local: pokemonList().local, timestamp: anyDate())
        stub.startIntercepting()
        
        XCTAssertThrowsError(try sut.delete())
    }
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        let sut = makeSut()
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        let list = pokemonList().local
        let timestamp = anyDate()
        try? sut.insert(local: pokemonList().local, timestamp: timestamp)
        stub.startIntercepting()
        
        try? sut.delete()
        
        expect(sut, toRetrieveTwice: .success(.init(local: list, timestamp: timestamp)))
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> PokemonListStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = CoreDataPokemonListStore(storeUrl: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(
        _ sut: PokemonListStore,
        toRetrieveTwice expectedResult: Result<CachedPokemonList?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(
        _ sut: PokemonListStore,
        toRetrieve expectedResult: Result<CachedPokemonList?, Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let retrievedResult = Result { try sut.retrieve() }
        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
             (.failure, .failure):
            break
            
        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved.local, expected.local, file: file, line: line)
            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
