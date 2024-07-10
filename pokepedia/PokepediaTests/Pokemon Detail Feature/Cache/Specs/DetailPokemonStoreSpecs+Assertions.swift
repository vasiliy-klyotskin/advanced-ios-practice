//
//  CoreDataDetailPokemonStoreSpecs+Assertions.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import XCTest
import Pokepedia

extension DetailPokemonStoreSpecs where Self: XCTestCase {
    func assertThat_retrieveForId_returnsEmptyOnEmptyCache(
        sut: () -> DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        ids.forEach { id in
            let sut = sut()
            
            let retrieval = sut.retrieve(for: id)
            
            XCTAssertEqual(retrieval, nil, file: file, line: line)
        }
    }
    
    func assertThat_retrieveForValidation_returnsEmptyOnEmptyCache(
        sut: DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let validationRetrieval = try sut.retrieveForValidation()
        
        XCTAssertEqual(validationRetrieval, [], file: file, line: line)
    }
    
    func assertThat_retrieveForId_returnsCacheForIdWhenCacheIsNotEmpty(
        sut: DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        insertCacheForIds(sut: sut)
        
        ids.forEach { id in
            let retrieval = sut.retrieve(for: id)
            
            XCTAssertEqual(retrieval, cache(for: id), file: file, line: line)
        }
    }
    
    func assertThat_retrieveForValidation_returnsValidationRetrievalWhenCacheIsNotEmpty(
        sut: DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        insertCacheForIds(sut: sut)
        
        let receivedValidationRetrieval = try sut.retrieveForValidation()
        
        let expectedRetrievals = ids.map { validationRetrieval(for: $0) }
        XCTAssertEqual(Set(receivedValidationRetrieval), Set(expectedRetrievals), file: file, line: line)
    }
    
    func assertThat_deleteForId_deletesCacheForParticularId(
        sut: DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        sut.insert(cache(for: 0), for: 0)
        sut.insert(cache(for: 7), for: 7)
        
        sut.delete(for: 7)
        
        XCTAssertEqual(sut.retrieve(for: 0), cache(for: 0), file: file, line: line)
        XCTAssertEqual(sut.retrieve(for: 7), nil, file: file, line: line)
    }
    
    func assertThat_deleteForId_affectsValidationRetrieval(
        sut: DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        sut.insert(cache(for: 0), for: 0)
        sut.insert(cache(for: 7), for: 7)
        
        sut.delete(for: 7)
        
        XCTAssertEqual(try sut.retrieveForValidation(), [validationRetrieval(for: 0)], file: file, line: line)
    }
    
    func assertThat_deleteAll_removesAllPokemons(
        sut: DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        insertCacheForIds(sut: sut)
        
        sut.deleteAll()
        
        ids.forEach { id in
            XCTAssertEqual(sut.retrieve(for: id), nil, file: file, line: line)
        }
    }
    
    func assertThat_DeleteAll_cauesesValidationRetrievalsAreEmpty(
        sut: DetailPokemonStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        insertCacheForIds(sut: sut)
        
        sut.deleteAll()
        
        XCTAssertEqual(try sut.retrieveForValidation(), [], file: file, line: line)
    }
    
    // MARK: - Helpers
    
    private var ids: [Int] { [0, 1, 2] }
    
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
