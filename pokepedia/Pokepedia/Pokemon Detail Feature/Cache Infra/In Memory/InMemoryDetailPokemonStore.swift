//
//  InMemoryDetailPokemonStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation

public final class InMemoryDetailPokemonStore: DetailPokemonStore {
    private var cache: [Int: DetailPokemonCache]
    
    public init(cache: [Int : DetailPokemonCache] = [:]) {
        self.cache = cache
    }
    
    public func retrieveForValidation() throws -> [Pokepedia.DetailPokemonValidationRetrieval] {
        cache.values.map { .init(timestamp: $0.timestamp, id: $0.local.info.id) }
    }
    
    public func deleteAll() {
        cache = [:]
    }
    
    public func retrieve(for id: Int) -> DetailPokemonCache? {
        cache[id]
    }
    
    public func delete(for id: Int) {
        cache[id] = nil
    }
    
    public func insert(_ cache: DetailPokemonCache, for id: Int) {
        self.cache[id] = cache
    }
}
