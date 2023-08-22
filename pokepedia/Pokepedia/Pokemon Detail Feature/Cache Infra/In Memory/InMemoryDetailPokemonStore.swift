//
//  InMemoryDetailPokemonStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation

public final class InMemoryDetailPokemonStore {
    private var cache: [Int: DetailPokemonCache]
    private var imageCache: [URL: Data]
    
    public init(cache: [Int : DetailPokemonCache] = [:], imageCache: [URL: Data] = [:]) {
        self.cache = cache
        self.imageCache = imageCache
    }
}

extension InMemoryDetailPokemonStore: DetailPokemonStore {
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

extension InMemoryDetailPokemonStore: ImageStore {
    public func retrieveImage(for url: URL) throws -> Data? {
        imageCache[url]
    }
    
    public func insertImage(data: Data, for url: URL) throws {
        imageCache[url] = data
    }
}
