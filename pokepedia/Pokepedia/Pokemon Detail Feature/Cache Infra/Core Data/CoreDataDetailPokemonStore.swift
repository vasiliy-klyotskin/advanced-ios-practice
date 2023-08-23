//
//  CoreDataDetailPokemonStore.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation
import CoreData

public final class CoreDataDetailPokemonStore {
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
    
    func performSync<R>(_ action: (NSManagedObjectContext) throws -> R) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = Result { try action(context) } }
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
