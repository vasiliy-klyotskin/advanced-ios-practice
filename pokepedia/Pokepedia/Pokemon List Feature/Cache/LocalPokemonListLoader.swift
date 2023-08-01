//
//  LocalPokemonListLoader.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/31/23.
//

import Foundation

public typealias CachedPokemonList = (local: LocalPokemonList, timestamp: Date)

public protocol LocalPokemonListStore {
    func retrieve() throws -> CachedPokemonList?
    func delete() throws
    func insert(local: LocalPokemonList, timestamp: Date) throws
}

public final class LocalPokemonListLoader {
    private let store: LocalPokemonListStore
    private let currentDate: () -> Date
    
    public init(store: LocalPokemonListStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalPokemonListLoader {
    public func load() throws -> PokemonList? {
        let cache = try store.retrieve()
        guard let cache else { return nil }
        if PokemonListCachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.local.model
        } else {
            return nil
        }
    }
    
}

extension LocalPokemonListLoader {
    public func save(_ list: PokemonList) throws {
        try store.delete()
        try store.insert(local: list.local, timestamp: currentDate())
    }
}

extension LocalPokemonListLoader {
    struct InvalidCache: Error {}
    
    public func validateCache() throws {
        do {
            if let cache = try store.retrieve(), !PokemonListCachePolicy.validate(cache.timestamp, against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try store.delete()
        }
    }
}
