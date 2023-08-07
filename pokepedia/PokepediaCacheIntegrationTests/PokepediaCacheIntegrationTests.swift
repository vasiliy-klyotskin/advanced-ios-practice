//
//  PokepediaCacheIntegrationTests.swift
//  PokepediaCacheIntegrationTests
//
//  Created by Василий Клецкин on 8/7/23.
//

import XCTest
import Pokepedia

final class PokepediaCacheIntegrationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_loadList_deliversNoListOnEmptyCache() throws {
        let listLoader = makeListLoader()
        
        XCTAssertNil(try listLoader.load())
    }
    
    func test_loadList_deliversListSavedOnASeparateInstance() throws {
        let listLoaderToPerformSave = makeListLoader()
        let listLoaderToPerformLoad = makeListLoader()
        let list = pokemonList().model
        
        try listLoaderToPerformSave.save(list)
        
        XCTAssertEqual(list, try listLoaderToPerformLoad.load())
    }
    
    func test_saveList_overridesListSavedOnASeparateInstance() throws {
        let listLoaderToPerformFirstSave = makeListLoader()
        let listLoaderToPerformLastSave = makeListLoader()
        let listLoaderToPerformLoad = makeListLoader()
        let firstList = pokemonList().model
        let latestList = pokemonList().model
        
        try listLoaderToPerformFirstSave.save(firstList)
        try listLoaderToPerformLastSave.save(latestList)

        XCTAssertEqual(latestList, try listLoaderToPerformLoad.load())
    }

    
    // MARK: - Helpers
    
    private func makeListLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalPokemonListLoader {
        let storeUrl = testSpecificStoreURL()
        let store = try! CoreDataPokemonListStore(storeUrl: storeUrl)
        let loader = LocalPokemonListLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}
