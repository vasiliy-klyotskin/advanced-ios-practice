//
//  InMemoryPokemonListStore.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/6/23.
//

import Foundation

public final class InMemoryPokemonListStore {
    private var listCache: CachedPokemonList?
    private var listImagesCache = [URL: Data]()
    
    public init(listCache: CachedPokemonList? = nil) {
        self.listCache = listCache
    }
}

extension InMemoryPokemonListStore: PokemonListStore {
    public func retrieve() throws -> CachedPokemonList? {
        listCache
    }
    
    public func delete() throws {
        listCache = nil
    }
    
    public func insert(local: LocalPokemonList, timestamp: Date) throws {
        listCache = .init(local: local, timestamp: timestamp)
    }
}

extension InMemoryPokemonListStore: ImageStore {
    public func retrieveImage(for url: URL) throws -> Data? {
        listImagesCache[url]
    }
    
    public func insertImage(data: Data, for url: URL) throws {
        listImagesCache[url] = data
    }
}
