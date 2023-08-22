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
        []
    }
    
    public func deleteAll() {
        
    }
    
    public func retrieve(for id: Int) -> DetailPokemonCache? {
        try? performSync { context in
            Result {
                let managedPokemon = try ManagedDetailPokemon.first(with: id, in: context)
                return .init(timestamp: managedPokemon.timestamp, local: managedPokemon.local)
            }
        }
    }
    
    public func delete(for id: Int) {
        
    }
    
    public func insert(_ cache: DetailPokemonCache, for id: Int) {
        try? performSync { context in
            Result {
                let container = ManagedDetailPokemonCache.instance(in: context)
                let managedPokemon = cache.managedPokemon(id: id, context: context)
                managedPokemon.cache = container
                try context.save()
            }
        }
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}

extension DetailPokemonCache {
    func managedPokemon(id: Int, context: NSManagedObjectContext) -> ManagedDetailPokemon {
        let pokemon = ManagedDetailPokemon.newUniqueInstance(for: id, in: context)
        pokemon.timestamp = timestamp
        pokemon.id = id
        pokemon.genus = local.info.genus
        pokemon.flavorText = local.info.flavorText
        pokemon.imageUrl = local.info.imageUrl
        pokemon.name = local.info.name
        pokemon.abilities = NSOrderedSet(array: local.abilities.map {
            let ability = ManagedDetailPokemonAbility(context: context)
            ability.damageClass = $0.damageClass
            ability.damageColor = $0.damageClassColor
            ability.type = $0.type
            ability.typeColor = $0.typeColor
            ability.title = $0.title
            ability.subtitle = $0.subtitle
            return ability
        })
        return pokemon
    }
}
