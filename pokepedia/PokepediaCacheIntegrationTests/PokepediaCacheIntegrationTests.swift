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
    
    // MARK: - LocalPokemonListLoader (CoreDataPokemonListStore) Tests
    
    func test_loadList_deliversNoListOnEmptyCache() {
        let listLoader = makeListLoader()
        
        expect(listLoader, toLoad: nil)
    }
    
    func test_loadList_deliversListSavedOnASeparateInstance() {
        let listLoaderToPerformSave = makeListLoader()
        let listLoaderToPerformLoad = makeListLoader()
        let list = pokemonList().model
        
        save(list, with: listLoaderToPerformSave)
        
        expect(listLoaderToPerformLoad, toLoad: list)
    }
    
    func test_saveList_overridesListSavedOnASeparateInstance() {
        let listLoaderToPerformFirstSave = makeListLoader()
        let listLoaderToPerformLastSave = makeListLoader()
        let listLoaderToPerformLoad = makeListLoader()
        let firstList = pokemonList().model
        let latestList = pokemonList().model
        
        save(firstList, with: listLoaderToPerformFirstSave)
        save(latestList, with: listLoaderToPerformLastSave)
        
        expect(listLoaderToPerformLoad, toLoad: latestList)
    }
    
    func test_validateListCache_doesNotDeleteRecentlySavedList() {
        let listLoaderToPerformSave = makeListLoader()
        let listLoaderToPerformValidation = makeListLoader()
        let listLoaderToPerformLoad = makeListLoader()
        let list = pokemonList().model
        
        save(list, with: listLoaderToPerformSave)
        validateCache(with: listLoaderToPerformValidation)

        expect(listLoaderToPerformLoad, toLoad: list)
    }
    
    func test_validateListCache_deletesListSavedInADistantPast() {
        let listLoaderToPerformSave = makeListLoader(currentDate: .distantPast)
        let listLoaderToPerformValidation = makeListLoader(currentDate: Date())
        let list = pokemonList().model
        
        save(list, with: listLoaderToPerformSave)
        validateCache(with: listLoaderToPerformValidation)

        expect(listLoaderToPerformSave, toLoad: nil)
    }
    
    // MARK: - LocalPokemonListImageLoader (CoreDataPokemonListImageStore) Tests
    
    func test_loadImageData_deliversSavedDataOnASeparateInstance() {
        let imageLoaderToPerformSave = makeImageLoader()
        let imageLoaderToPerformLoad = makeImageLoader()
        let listLoader = makeListLoader()
        let list = pokemonList().model
        let imageUrl = list.first!.imageUrl
        let dataToSave = Data("any data".utf8)
        
        save(list, with: listLoader)
        save(dataToSave, for: imageUrl, with: imageLoaderToPerformSave)
        
        expect(imageLoaderToPerformLoad, toLoad: dataToSave, for: imageUrl)
    }
    
    func test_saveImageData_overridesSavedImageDataOnASeparateInstance() {
        let imageLoaderToPerformFirstSave = makeImageLoader()
        let imageLoaderToPerformLastSave = makeImageLoader()
        let imageLoaderToPerformLoad = makeImageLoader()
        let feedLoader = makeListLoader()
        let list = pokemonList().model
        let imageUrl = list.first!.imageUrl
        let firstImageData = Data("first".utf8)
        let lastImageData = Data("last".utf8)
        
        save(list, with: feedLoader)
        save(firstImageData, for: imageUrl, with: imageLoaderToPerformFirstSave)
        save(lastImageData, for: imageUrl, with: imageLoaderToPerformLastSave)
        
        expect(imageLoaderToPerformLoad, toLoad: lastImageData, for: imageUrl)
    }
    
    // MARK: - Helpers
    
    private func makeListLoader(
        currentDate: Date = .init(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LocalPokemonListLoader {
        let storeUrl = testSpecificStoreURL()
        let store = try! CoreDataPokemonListStore(storeUrl: storeUrl)
        let loader = LocalPokemonListLoader(store: store, currentDate: { currentDate })
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }
    
    private func makeImageLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalPokemonListImageLoader {
        let storeUrl = testSpecificStoreURL()
        let store = try! CoreDataPokemonListStore(storeUrl: storeUrl)
        let loader = LocalPokemonListImageLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }
    
    private func save(_ list: PokemonList, with loader: LocalPokemonListLoader, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try loader.save(list)
        } catch {
            XCTFail("Expected to save list successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func validateCache(with loader: LocalPokemonListLoader, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try loader.validateCache()
        } catch {
            XCTFail("Expected to validate list successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func expect(_ sut: LocalPokemonListLoader, toLoad expectedList: PokemonList?, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let loadedList = try sut.load()
            XCTAssertEqual(loadedList, expectedList, file: file, line: line)
        } catch {
            XCTFail("Expected successful list result, got \(error) instead", file: file, line: line)
        }
    }
    
    private func save(_ data: Data, for url: URL, with loader: LocalPokemonListImageLoader, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try loader.save(data, for: url)
        } catch {
            XCTFail("Expected to save image data successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func expect(_ sut: LocalPokemonListImageLoader, toLoad expectedData: Data, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let loadedData = try sut.loadImageData(from: url)
            XCTAssertEqual(loadedData, expectedData, file: file, line: line)
        } catch {
            XCTFail("Expected successful image data result, got \(error) instead", file: file, line: line)
        }
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
