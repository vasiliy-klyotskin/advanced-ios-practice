//
//  InMemoryDetailPokemonStore+DSL.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Vasiliy Klyotskin on 8/25/23.
//

import Foundation
import Pokepedia

extension InMemoryDetailPokemonStore {
    static var empty: InMemoryDetailPokemonStore { .init() }
    
    static func withExpiredDetailCache(for id: Int) -> InMemoryDetailPokemonStore {
        let local = anyLocal(for: id)
        let cache = [id: DetailPokemonCache(timestamp: .distantPast, local: local)]
        return .init(cache: cache, imageCache: [local.info.imageUrl: Data("any data".utf8)])
    }

    static func withNonExpiredDetailCache(for id: Int) -> InMemoryDetailPokemonStore {
        let local = anyLocal(for: id)
        let cache = [id: DetailPokemonCache(timestamp: Date(), local: local)]
        return .init(cache: cache, imageCache: [local.info.imageUrl: Data("any data".utf8)])
    }
    
    private static func anyLocal(for id: Int) -> LocalDetailPokemon {
        .init(
            info: .init(
                imageUrl: anyURL(),
                id: id,
                name: "any",
                genus: "any",
                flavorText: "any"
            ),
            abilities: []
        )
    }
}
