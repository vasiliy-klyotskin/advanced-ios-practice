//
//  ManagedPokemonListCache+CoreDataClass.swift
//  
//
//  Created by Василий Клецкин on 8/3/23.
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
    
    var local: LocalPokemonList {
        return pokemonList.compactMap { ($0 as? ManagedPokemonListItem)?.local }
    }
}
