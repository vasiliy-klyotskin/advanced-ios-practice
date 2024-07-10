//
//  ManagedPokemonListCache+CoreDataClass.swift
//  
//
//  Created by Vasiliy Klyotskin on 8/3/23.
//
//

import CoreData

@objc(ManagedPokemonListCache)
public class ManagedPokemonListCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var pokemonList: NSOrderedSet
}

extension ManagedPokemonListCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedPokemonListCache? {
        let request = NSFetchRequest<ManagedPokemonListCache>(entityName: entity().name!)
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedPokemonListCache {
        try deleteCache(in: context)
        return ManagedPokemonListCache(context: context)
    }
    
    var local: LocalPokemonList {
        return pokemonList.compactMap { ($0 as? ManagedPokemonListItem)?.local }
    }
}
