//
//  CoreDataLocalPokemonListStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/3/23.
//

import CoreData

public final class CoreDataLocalPokemonListStore: LocalPokemonListStore {
    private static let modelName = "PokemonListStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataLocalPokemonListStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeUrl: URL) {
        container = try! NSPersistentContainer.load(
            name: Self.modelName,
            model: Self.model!,
            url: storeUrl
        )
        context = container.newBackgroundContext()
    }
    
    public func retrieve() throws -> CachedPokemonList? {
        try performSync { context in
            Result {
                try ManagedPokemonListCache.find(in: context).map {
                    .init(local: $0.local, timestamp: $0.timestamp)
                }
            }
        }
    }
    
    public func delete() throws {
        try performSync { context in
            Result {
                try ManagedPokemonListCache.deleteCache(in: context)
            }
        }
    }
    
    public func insert(local: LocalPokemonList, timestamp: Date) throws {
        try performSync { context in
            Result {
                let cache = try ManagedPokemonListCache.newUniqueInstance(in: context)
                let list = ManagedPokemonListItem.listItems(from: local, in: context)
                cache.timestamp = timestamp
                cache.pokemonList = list
                try context.save()
            }
        }
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}
