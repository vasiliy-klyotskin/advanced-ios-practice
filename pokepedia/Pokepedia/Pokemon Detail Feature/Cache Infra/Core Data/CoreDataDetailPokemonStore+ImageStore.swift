//
//  CoreDataDetailPokemonStore+ImageStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation

extension CoreDataDetailPokemonStore: ImageStore {
    public func retrieveImage(for url: URL) throws -> Data? {
        try performSync { context in
            try ManagedDetailPokemon.imageData(for: url, in: context)
        }
    }
    
    public func insertImage(data: Data, for url: URL) throws {
        try performSync { context in
            try ManagedDetailPokemon.first(with: url, in: context)
                .map { $0.imageData = data }
                .map(context.save)
        }
    }
}
