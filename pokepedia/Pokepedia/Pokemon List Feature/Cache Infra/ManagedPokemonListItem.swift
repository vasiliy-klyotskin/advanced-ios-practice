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

extension ManagedPokemonListItem {
    var local: LocalPokemonListItem {
        let specialType: LocalPokemonListItemType?
        if let specialColor, let specialName {
            specialType = .init(color: specialColor, name: specialName)
        } else {
            specialType = nil
        }
        return .init(id: id, name: name, imageUrl: imageUrl, physicalType: .init(color: physicalColor, name: physicalName), specialType: specialType)
    }
    
    static func listItems(from localList: LocalPokemonList, in context: NSManagedObjectContext) -> NSOrderedSet {
        let items = NSOrderedSet(array: localList.map { local in
            let managed = ManagedPokemonListItem(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.physicalColor = local.physicalType.color
            managed.physicalName = local.physicalType.name
            managed.specialColor = local.specialType?.color
            managed.specialName = local.specialType?.name
            managed.imageUrl = local.imageUrl
            return managed
        })
        return items
    }
}
