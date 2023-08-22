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
    
    func test_retrieveForValidation_returnsEmptyOnEmptyCache() throws {
        let sut = makeSut()
        
        let validationRetrieval = try sut.retrieveForValidation()
        
        XCTAssertEqual(validationRetrieval, [])
    }
    
    func test_retrieveForId_returnsCacheForIdWhenCacheIsNotEmpty() throws {
        let sut = makeSut()
        insertCacheForIds(sut: sut)
        
        ids.forEach { id in
            let retrieval = sut.retrieve(for: id)
            
            XCTAssertEqual(retrieval, cache(for: id))
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
    
    private func cache(for id: Int) -> DetailPokemonCache {
        let date = Date.distantPast.addingTimeInterval(TimeInterval(id))
        return .init(timestamp: date, local: localDetail(for: id).local)
    }
    
    private func insertCacheForIds(sut: DetailPokemonStore) {
        ids.forEach { id in
            sut.insert(cache(for: id), for: id)
        }
    }
}
