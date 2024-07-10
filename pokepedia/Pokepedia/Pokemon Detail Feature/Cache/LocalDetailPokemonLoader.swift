//
//  LocalDetailPokemonLoader.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Foundation

public protocol DetailPokemonStore {
    func retrieveForValidation() throws -> [DetailPokemonValidationRetrieval]
    func deleteAll()
    func retrieve(for id: Int) -> DetailPokemonCache?
    func delete(for id: Int)
    func insert(_ cache: DetailPokemonCache, for id: Int)
}

public final class LocalDetailPokemonLoader {
    typealias Retrieval = DetailPokemonValidationRetrieval
    typealias Cache = DetailPokemonCache
    
    private let store: DetailPokemonStore
    private let currentDate: () -> Date
    
    enum Error: Swift.Error {
        case empty, expired
    }
    
    public init(store: DetailPokemonStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalDetailPokemonLoader {
    public func load(for id: Int) throws -> DetailPokemon {
        let cache = store.retrieve(for: id)
        guard let cache else { throw Error.empty }
        if validate(cache) {
            return cache.local.model
        } else {
            throw Error.expired
        }
    }
    
    private func validate(_ retrieval: Cache) -> Bool {
        DetailPokemonCachePolicy.validate(retrieval.timestamp, against: currentDate())
    }
}

extension LocalDetailPokemonLoader: DetailPokemonSaveCache {
    public func save(detail: DetailPokemon) {
        let id = detail.info.id
        store.delete(for: id)
        let cache = Cache(timestamp: currentDate(), local: detail.local)
        store.insert(cache, for: id)
    }
}

extension LocalDetailPokemonLoader {
    public func validateCache() {
        do {
            try store.retrieveForValidation().forEach(validate(retrieval:))
        } catch {
            store.deleteAll()
        }
    }
    
    private func validate(retrieval: Retrieval) {
        if !DetailPokemonCachePolicy.validate(retrieval.timestamp, against: currentDate()) {
            store.delete(for: retrieval.id)
        }
    }
}
