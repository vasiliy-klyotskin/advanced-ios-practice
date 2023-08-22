//
//  LocalDetailPokemonLoader.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation

public protocol DetailPokemonStore {
    func retrieve() throws -> [LocalDetailPokemonLoader.ValidationRetrieval]
    func deleteAll()
    func delete(for id: Int) throws
    func insert(_ cache: LocalDetailPokemonLoader.Insertion, for id: Int)
}

public final class LocalDetailPokemonLoader {
    private let store: DetailPokemonStore
    private let currentDate: () -> Date
    
    public init(store: DetailPokemonStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(detail: DetailPokemon) {
        do {
            let id = detail.info.id
            try store.delete(for: id)
            let insertion = Insertion(timestamp: currentDate(), local: detail.local)
            store.insert(insertion, for: id)
        } catch {}
    }
    
    public func validateCache() {
        do {
            try store.retrieve().forEach(validate(retrieval:))
        } catch {
            store.deleteAll()
        }
    }
    
    private func validate(retrieval: ValidationRetrieval) {
        if !DetailPokemonCachePolicy.validate(retrieval.timestamp, against: currentDate()) {
            try? store.delete(for: retrieval.id)
        }
    }
    
    public struct Insertion: Equatable {
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
