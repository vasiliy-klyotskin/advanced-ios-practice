//
//  InMemoryPokemonListStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/6/23.
//

import Foundation

public final class InMemoryPokemonListStore: PokemonListStore, PokemonListImageStore {
    private var cache: CachedPokemonList?
    private var images = [URL: Data]()
    
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
    
    public func retrieveImage(for url: URL) throws -> Data? {
        images[url]
    }
    
    public func insertImage(data: Data, for url: URL) throws {
        images[url] = data
    }
}
