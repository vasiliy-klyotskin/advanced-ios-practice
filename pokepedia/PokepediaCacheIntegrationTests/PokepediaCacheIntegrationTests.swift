//
//  PokepediaCacheIntegrationTests.swift
//  PokepediaCacheIntegrationTests
//
//  Created by Василий Клецкин on 8/7/23.
//

import XCTest
import Pokepedia

final class PokepediaCacheIntegrationTests: XCTestCase {
    func test_loadList_deliversNoListOnEmptyCache() throws {
        let listLoader = makeListLoader()
        
        XCTAssertNil(try listLoader.load())
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
}
