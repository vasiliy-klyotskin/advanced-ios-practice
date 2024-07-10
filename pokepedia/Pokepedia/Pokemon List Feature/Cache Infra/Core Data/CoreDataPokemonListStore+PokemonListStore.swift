//
//  CoreDataPokemonListStore+PokemonListStore.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/4/23.
//

import Foundation
import CoreData

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
            Result { try deleteCache(in: context) }
        }
    }
    
    public func insert(local: LocalPokemonList, timestamp: Date) throws {
        try performSync { context in
            Result {
                try insertInto(
                    context: context,
                    local: local,
                    timestamp: timestamp
                )
            }
        }
    }
    
    private func deleteCache(in context: NSManagedObjectContext) throws {
        do {
            try ManagedPokemonListCache.deleteCache(in: context)
        } catch {
            context.reset()
            throw error
        }
    }
    
    private func insertInto(
        context: NSManagedObjectContext,
        local: LocalPokemonList,
        timestamp: Date
    ) throws {
        do {
            let cache = try ManagedPokemonListCache.newUniqueInstance(in: context)
            let list = ManagedPokemonListItem.listItems(from: local, in: context)
            cache.timestamp = timestamp
            cache.pokemonList = list
            try context.save()
        } catch {
            context.reset()
            throw error
        }
    }
}
