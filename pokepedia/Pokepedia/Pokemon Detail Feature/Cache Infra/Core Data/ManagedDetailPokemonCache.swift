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
//    static func deleteCache(in context: NSManagedObjectContext) throws {
//        try find(in: context).map(context.delete).map(context.save)
//    }
    
    static func instance(in context: NSManagedObjectContext) -> ManagedDetailPokemonCache {
        return find(in: context) ?? .init(context: context)
    }
    
    private static func find(in context: NSManagedObjectContext) -> ManagedDetailPokemonCache? {
        let request = NSFetchRequest<ManagedDetailPokemonCache>(entityName: entity().name!)
        return try? context.fetch(request).first
    }
}
