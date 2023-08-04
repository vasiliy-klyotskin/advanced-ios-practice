//
//  CoreDataPokemonListStore+PokemonListStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/4/23.
//

import Foundation

extension CoreDataPokemonListStore: PokemonListStore {
    public func retrieve() throws -> CachedPokemonList? {
        try performSync { context in
            Result {
                try ManagedPokemonListCache.find(in: context).map {
                    .init(local: $0.local, timestamp: $0.timestamp)
                }
            }
        }
    }
    
    public func delete() throws {
        try performSync { context in
            Result {
                try ManagedPokemonListCache.deleteCache(in: context)
            }
        }
    }
    
    public func insert(local: LocalPokemonList, timestamp: Date) throws {
        try performSync { context in
            Result {
                let cache = try ManagedPokemonListCache.newUniqueInstance(in: context)
                let list = ManagedPokemonListItem.listItems(from: local, in: context)
                cache.timestamp = timestamp
                cache.pokemonList = list
                try context.save()
            }
        }
    }
}
