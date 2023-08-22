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
    func delete(for id: Int)
}

public final class LocalDetailPokemonLoader {
    private let store: DetailPokemonStore
    private let currentDate: () -> Date
    
    public init(store: DetailPokemonStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
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
            store.delete(for: retrieval.id)
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
