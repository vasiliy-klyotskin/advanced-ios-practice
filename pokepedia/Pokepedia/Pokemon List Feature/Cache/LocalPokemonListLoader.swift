//
//  LocalPokemonListLoader.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/31/23.
//

import Foundation

public protocol PokemonListStore {
    func retrieve() throws -> CachedPokemonList?
    func delete() throws
    func insert(local: LocalPokemonList, timestamp: Date) throws
}

public final class LocalPokemonListLoader: PokemonListCache {
    private let store: PokemonListStore
    private let currentDate: () -> Date
    
    public init(store: PokemonListStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalPokemonListLoader {
    enum LocalLoadError: Error {
        case empty, expired
    }
    
    public func load() throws -> PokemonList {
        let cache = try store.retrieve()
        guard let cache else { throw LocalLoadError.empty }
        if PokemonListCachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.local.model
        } else {
            throw LocalLoadError.expired
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
