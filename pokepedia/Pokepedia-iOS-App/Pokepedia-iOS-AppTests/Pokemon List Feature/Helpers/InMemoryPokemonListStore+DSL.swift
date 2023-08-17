//
//  InMemoryPokemonListStore+DSL.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 8/16/23.
//

import Pokepedia
import Foundation

extension InMemoryPokemonListStore {
    static var empty: InMemoryPokemonListStore { .init() }
    
    static var withExpiredFeedCache: InMemoryPokemonListStore {
        .init(listCache: .init(local: [], timestamp: .distantPast))
    }
    
    static var withNonExpiredFeedCache: InMemoryPokemonListStore {
        .init(listCache: .init(local: [], timestamp: Date()))
    }
}
