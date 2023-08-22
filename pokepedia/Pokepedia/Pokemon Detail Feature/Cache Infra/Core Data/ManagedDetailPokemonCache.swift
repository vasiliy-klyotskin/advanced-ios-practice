//
//  ManagedDetailPokemonCache.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import CoreData

@objc(ManagedDetailPokemonCache)
public class ManagedDetailPokemonCache: NSManagedObject {
    @NSManaged var details: NSSet
}

extension ManagedDetailPokemonCache {
    static func deleteCache(in context: NSManagedObjectContext) {
        try? find(in: context).map(context.delete).map(context.save)
    }
    
    static func retrievals(in context: NSManagedObjectContext) throws -> [DetailPokemonValidationRetrieval] {
        try find(in: context)?.details
            .compactMap { $0 as? ManagedDetailPokemon }
            .map { .init(timestamp: $0.timestamp, id: $0.id) } ?? []
    }
    
    static func instance(in context: NSManagedObjectContext) -> ManagedDetailPokemonCache {
        return (try? find(in: context)) ?? .init(context: context)
    }
    
    private static func find(in context: NSManagedObjectContext) throws -> ManagedDetailPokemonCache? {
        let request = NSFetchRequest<ManagedDetailPokemonCache>(entityName: entity().name!)
        return try context.fetch(request).first
    }
}
