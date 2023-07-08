//
//  PokemonListCacheIntegrationTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/8/23.
//

import XCTest
import Pokepedia

final class PokemonListCacheFacade {
    private let loader: LocalLoader<PokemonList, PokemonList>
    private let saver: LocalSaver<PokemonList, PokemonList>
    
    private var storeKey: String { "pokemonList.cache" }
    
    init(
        loader: LocalLoader<PokemonList, PokemonList>,
        saver: LocalSaver<PokemonList, PokemonList>
    ) {
        self.loader = loader
        self.saver = saver
    }
    
    func loadList() throws -> PokemonList {
        try loader.load(for: storeKey)
    }
    
    func save(list: PokemonList) {
        saver.save(list, for: storeKey)
    }
    
    func validate() {
        
    }
}

enum PokemonListCacheComposer {
    static func compose(
        timestamp: @escaping () -> Date = Date.init,
        loadMomentDate: @escaping () -> Date = Date.init
    ) -> PokemonListCacheFacade {
        let store = InMemoryStore<PokemonList>()
        return PokemonListCacheFacade(
            loader: .init(
                store: store,
                mapping: { $0 },
                validation: against(loadMomentDate: loadMomentDate)
            ),
            saver: .init(
                store: store,
                mapping: { $0 },
                current: timestamp
            )
        )
    }
    
    private static func against(loadMomentDate: @escaping () -> Date) -> (Date) -> Bool {
        { timestamp in
            PokemonListCachePolicy.validate(timestamp, against: loadMomentDate())
        }
    }
}

final class PokemonListCacheIntegrationTests: XCTestCase {
    
    func test_deliverNoListOnEmptyCache() {
        let sut = makeSut()
        
        let list = try? sut.loadList()
        
        XCTAssertNil(list)
    }
    
    func test_deliversListOnNotEmptyCache() {
        let sut = makeSut()
        let pokemon0 = makeListPokemon()
        let pokemon1 = makeListPokemon(specialType: .init(color: "type color", name: "type name"))
        let listForSaving = [pokemon0, pokemon1]
        sut.save(list: listForSaving)
        
        let loadedList = try? sut.loadList()
        
        XCTAssertEqual(listForSaving, loadedList)
    }
    
    func test_validateDoesNotDeleteCacheOnNotExpiredDate() {
        let timestamp = Date()
        let notExpiredDate = timestamp.plusFeedCacheMaxAge().adding(seconds: -1)
        let sut = makeSut(
            timestamp: timestamp,
            loadMomentDate: notExpiredDate
        )
        let pokemon0 = makeListPokemon()
        let pokemon1 = makeListPokemon(specialType: .init(color: "type color", name: "type name"))
        let listForSaving = [pokemon0, pokemon1]
        sut.save(list: listForSaving)
        sut.validate()
        
        let loadedList = try? sut.loadList()
        
        XCTAssertEqual(listForSaving, loadedList)
    }
    
    // MARK: - Helpers
    
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
    
    private func makeListPokemon(specialType: PokemonListItemType? = nil) -> PokemonListItem {
        .init(
            id: anyId(),
            name: anyName(),
            imageUrl: anyURL(),
            physicalType: itemType(),
            specialType: specialType
        )
    }
    
    private func itemType() -> PokemonListItemType {
        .init(color: anyId(), name: anyName())
    }
}
