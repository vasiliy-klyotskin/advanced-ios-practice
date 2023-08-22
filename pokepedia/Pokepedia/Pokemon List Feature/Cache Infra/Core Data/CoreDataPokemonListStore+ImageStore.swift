//
//  CoreDataPokemonListStore+ImageStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/4/23.
//

import Foundation

extension CoreDataPokemonListStore: ImageStore {
    public func retrieveImage(for url: URL) throws -> Data? {
        try performSync { context in
            Result {
                try ManagedPokemonListItem.imageData(with: url, in: context)
            }
        }
    }
    
    public func insertImage(data: Data, for url: URL) throws {
        try performSync { context in
            Result {
                try ManagedPokemonListItem.first(with: url, in: context)
                    .map { $0.imageData = data }
                    .map(context.save)
            }
        }
    }
}
