//
//  CoreDataDetailPokemonStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import XCTest
import Pokepedia

final class CoreDataDetailPokemonStoreTests: XCTestCase {
    func test_retrieveForId_returnsEmptyOnEmptyCache() throws {
        ids.forEach { id in
            let sut = makeSut()
            
            let retrieval = sut.retrieve(for: id)
            
            XCTAssertEqual(retrieval, nil)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> DetailPokemonStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataDetailPokemonStore(storeUrl: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private let ids = [0, 1, 2]
}
