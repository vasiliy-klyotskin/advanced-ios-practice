//
//  CoreDataLocalPokemonListStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/3/23.
//

import CoreData

public final class CoreDataPokemonListStore {
    private static let modelName = "PokemonListStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataPokemonListStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public struct ModelNotFound: Error {
        public let modelName: String
    }

    public init(storeUrl: URL) throws {
        guard let model = CoreDataPokemonListStore.model else {
            throw ModelNotFound(modelName: CoreDataPokemonListStore.modelName)
        }

        container = try NSPersistentContainer.load(
            name: CoreDataPokemonListStore.modelName,
            model: model,
            url: storeUrl
        )
        context = container.newBackgroundContext()
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}
