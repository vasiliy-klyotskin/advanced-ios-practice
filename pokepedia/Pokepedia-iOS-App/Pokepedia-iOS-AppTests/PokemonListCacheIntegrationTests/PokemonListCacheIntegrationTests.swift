//
//  PokemonListCacheIntegrationTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/8/23.
//

import XCTest
import Pokepedia
import Pokepedia_iOS_App

final class PokemonListCacheIntegrationTests: XCTestCase {
    func test_deliverNoListOnEmptyCache() {
        let sut = makeSut()
        
        let list = try? sut.loadList()
        
        XCTAssertNil(list)
    }
    
    func test_loadDeliversCacheOnNotExpiredDate() {
        let timestamp = Date()
        let notExpiredDate = timestamp.plusFeedCacheMaxAge().adding(seconds: -1)
        let listForSaving = makeList()
        let sut = makeSut(
            timestamp: timestamp,
            loadMomentDate: notExpiredDate
        )
        
        sut.save(list: listForSaving)

        XCTAssertNoThrow(try sut.loadList())
    }
    
    func test_loadDoesNotDeliverCacheOnExpiredDate() {
        let timestamp = Date()
        let expiredDate = timestamp.plusFeedCacheMaxAge().adding(seconds: 1)
        let listForSaving = makeList()
        let sut = makeSut(
            timestamp: timestamp,
            loadMomentDate: expiredDate
        )
        
        sut.save(list: listForSaving)

        XCTAssertThrowsError(try sut.loadList()) { error in
            XCTAssertEqual(error as? CacheError, CacheError.expired)
        }
    }
    
    func test_validateDeletesCacheOnExpiredDate() {
        let timestamp = Date()
        let expiredDate = timestamp.plusFeedCacheMaxAge().adding(seconds: 1)
        let listForSaving = makeList()
        let sut = makeSut(
            timestamp: timestamp,
            loadMomentDate: expiredDate
        )
        
        sut.save(list: listForSaving)
        sut.validate()

        XCTAssertThrowsError(try sut.loadList()) { error in
            XCTAssertEqual(error as? CacheError, CacheError.empty)
        }
    }
    
    // MARK: - Helpers
    typealias CacheError = LocalLoader<PokemonList, PokemonList>.Error
    
    private func makeSut(
        timestamp: Date = .init(),
        loadMomentDate: Date = .init(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> PokemonListCacheFacade {
        PokemonListCacheComposer.compose(
            timestamp: { timestamp },
            loadMomentDate: { loadMomentDate }
        )
    }
    
    private func makeList() -> PokemonList {
        let pokemon0 = makeListPokemon()
        let pokemon1 = makeListPokemon(specialType:
            .init(color: "type color", name: "type name")
        )
        return [pokemon0, pokemon1]
    }
}
