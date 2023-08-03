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
