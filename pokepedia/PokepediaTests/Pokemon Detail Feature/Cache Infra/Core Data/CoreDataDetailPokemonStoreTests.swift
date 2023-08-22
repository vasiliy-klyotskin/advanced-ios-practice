//
//  CoreDataDetailPokemonStoreTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/22/23.
//

import XCTest
import Pokepedia

final class CoreDataDetailPokemonStoreTests: XCTestCase {
    func test_retrieveForId_returnsEmptyOnEmptyCache() {
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
    
    func test_retrieveForId_returnsCacheForIdWhenCacheIsNotEmpty() {
        let sut = makeSut()
        insertCacheForIds(sut: sut)
        
        ids.forEach { id in
            let retrieval = sut.retrieve(for: id)
            
            XCTAssertEqual(retrieval, cache(for: id))
        }
    }
    
    func test_retrieveForValidation_returnsValidationRetrievalWhenCacheIsNotEmpty() throws {
        let sut = makeSut()
        insertCacheForIds(sut: sut)
        
        let receivedValidationRetrieval = try sut.retrieveForValidation()
        
        let expectedRetrievals = ids.map { validationRetrieval(for: $0) }
        XCTAssertEqual(Set(receivedValidationRetrieval), Set(expectedRetrievals))
    }
    
    func test_deleteForId_deletesCacheForParticularId() throws {
        let sut = makeSut()
        sut.insert(cache(for: 0), for: 0)
        sut.insert(cache(for: 7), for: 7)
        
        sut.delete(for: 7)
        
        XCTAssertEqual(sut.retrieve(for: 0), cache(for: 0))
        XCTAssertEqual(sut.retrieve(for: 7), nil)
    }
    
    func test_deleteForId_affectsValidationRetrieval() {
        let sut = makeSut()
        sut.insert(cache(for: 0), for: 0)
        sut.insert(cache(for: 7), for: 7)
        
        sut.delete(for: 7)
        
        XCTAssertEqual(try sut.retrieveForValidation(), [validationRetrieval(for: 0)])
    }
    
    func test_deleteAll_removesAllPokemons() {
        let sut = makeSut()
        insertCacheForIds(sut: sut)
        
        sut.deleteAll()
        
        ids.forEach { id in
            XCTAssertEqual(sut.retrieve(for: id), nil)
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
    
    private func validationRetrieval(for id: Int) -> DetailPokemonValidationRetrieval {
        let cache = cache(for: id)
        return .init(timestamp: cache.timestamp, id: id)
    }
    
    private func insertCacheForIds(sut: DetailPokemonStore) {
        ids.forEach { id in
            sut.insert(cache(for: id), for: id)
        }
    }
}
