//
//  CoreDataDetailPokemonStore+DetailPokemonStore.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Foundation

extension CoreDataDetailPokemonStore: DetailPokemonStore {
    public func retrieveForValidation() throws -> [DetailPokemonValidationRetrieval] {
        try performSync { context in
            try ManagedDetailPokemonCache.retrievals(in: context)
        }
    }
    
    public func deleteAll() {
        try? performSync { context in
            ManagedDetailPokemonCache.deleteCache(in: context)
        }
    }
    
    public func retrieve(for id: Int) -> DetailPokemonCache? {
        try? performSync { context in
            let managedPokemon = ManagedDetailPokemon.first(with: id, in: context)
            return managedPokemon.map { .init(timestamp: $0.timestamp, local: $0.local) }
        }
    }
    
    public func delete(for id: Int) {
        try? performSync { context in
            ManagedDetailPokemon.delete(for: id, in: context)
        }
    }
    
    public func insert(_ cache: DetailPokemonCache, for id: Int) {
        try? performSync { context in
            let container = ManagedDetailPokemonCache.instance(in: context)
            let managedPokemon = cache.managedPokemon(id: id, context: context)
            managedPokemon.cache = container
            try? context.save()
        }
    }
}
