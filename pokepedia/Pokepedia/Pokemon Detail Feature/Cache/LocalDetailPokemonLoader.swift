//
//  LocalDetailPokemonLoader.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation

public protocol DetailPokemonStore {
    func retrieveForValidation() throws -> [LocalDetailPokemonLoader.ValidationRetrieval]
    func deleteAll()
    func retrieve(for id: Int) -> LocalDetailPokemonLoader.Cache?
    func delete(for id: Int)
    func insert(_ cache: LocalDetailPokemonLoader.Cache, for id: Int)
}

public final class LocalDetailPokemonLoader {
    private let store: DetailPokemonStore
    private let currentDate: () -> Date
    
    enum Error: Swift.Error {
        case empty, expired
    }
    
    public init(store: DetailPokemonStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load(for id: Int) throws -> DetailPokemon {
        let retrieval = store.retrieve(for: id)
        if let retrieval {
            if DetailPokemonCachePolicy.validate(retrieval.timestamp, against: currentDate()) {
                return retrieval.local.model
            } else {
                throw Error.expired
            }
        } else {
            throw Error.empty
        }
    }
    
    public func save(detail: DetailPokemon) {
        let id = detail.info.id
        store.delete(for: id)
        let cache = Cache(timestamp: currentDate(), local: detail.local)
        store.insert(cache, for: id)
    }
    
    public func validateCache() {
        do {
            try store.retrieveForValidation().forEach(validate(retrieval:))
        } catch {
            store.deleteAll()
        }
    }
    
    private func validate(retrieval: ValidationRetrieval) {
        if !DetailPokemonCachePolicy.validate(retrieval.timestamp, against: currentDate()) {
            store.delete(for: retrieval.id)
        }
    }
    
    public struct Cache: Equatable {
        public let timestamp: Date
        public let local: LocalDetailPokemon
        
        public init(timestamp: Date, local: LocalDetailPokemon) {
            self.timestamp = timestamp
            self.local = local
        }
    }
    
    public struct ValidationRetrieval {
        public let timestamp: Date
        public let id: Int
        
        public init(timestamp: Date, id: Int) {
            self.timestamp = timestamp
            self.id = id
        }
    }
}
