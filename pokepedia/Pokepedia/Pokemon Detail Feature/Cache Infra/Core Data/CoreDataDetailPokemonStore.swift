//
//  CoreDataDetailPokemonStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation
import CoreData

public final class CoreDataDetailPokemonStore: DetailPokemonStore {
    private static let modelName = "DetailPokemonStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataPokemonListStore.self))

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public struct ModelNotFound: Error {
        public let modelName: String
    }

    public init(storeUrl: URL) throws {
        guard let model = CoreDataDetailPokemonStore.model else {
            throw ModelNotFound(modelName: CoreDataDetailPokemonStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataDetailPokemonStore.modelName,
            model: model,
            url: storeUrl
        )
        context = container.newBackgroundContext()
    }
    
    public func retrieveForValidation() throws -> [DetailPokemonValidationRetrieval] {
        try performSync { context in
            try ManagedDetailPokemonCache.retrievals(in: context)
        }
    }
    
    public func deleteAll() {
        try? performSync { context in
            ManagedDetailPokemonCache.deleteCache(in: context)
        }
    }
    
    public func retrieve(for id: Int) -> DetailPokemonCache? {
        try? performSync { context in
            let managedPokemon = ManagedDetailPokemon.first(with: id, in: context)
            return managedPokemon.map { .init(timestamp: $0.timestamp, local: $0.local) }
        }
    }
    
    public func delete(for id: Int) {
        try? performSync { context in
            ManagedDetailPokemon.delete(for: id, in: context)
        }
    }
    
    public func insert(_ cache: DetailPokemonCache, for id: Int) {
        try? performSync { context in
            let container = ManagedDetailPokemonCache.instance(in: context)
            let managedPokemon = cache.managedPokemon(id: id, context: context)
            managedPokemon.cache = container
            try? context.save()
        }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) throws -> R) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = Result { try action(context) } }
        return try result.get()
    }
}
