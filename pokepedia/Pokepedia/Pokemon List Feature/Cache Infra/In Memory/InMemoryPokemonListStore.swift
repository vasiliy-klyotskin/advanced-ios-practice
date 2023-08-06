//
//  InMemoryPokemonListStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/6/23.
//

import Foundation

public final class InMemoryPokemonListStore: PokemonListStore {
    private var cache: CachedPokemonList?
    
    public init() {}
    
    public func retrieve() throws -> CachedPokemonList? {
        cache
    }
    
    public func delete() throws {
        cache = nil
    }
    
    public func insert(local: LocalPokemonList, timestamp: Date) throws {
        cache = .init(local: local, timestamp: timestamp)
    }
}
