//
//  ManagedPokemonListItem+CoreDataClass.swift
//  
//
//  Created by Василий Клецкин on 8/3/23.
//
//

import CoreData

@objc(ManagedPokemonListItem)
class ManagedPokemonListItem: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var imageUrl: URL
    @NSManaged var physicalColor: String
    @NSManaged var physicalName: String
    @NSManaged var specialColor: String?
    @NSManaged var specialName: String?
    @NSManaged var cache: ManagedPokemonListCache
}
