//
//  ManagedDetailPokemon.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import CoreData

@objc(ManagedDetailPokemon)
public class ManagedDetailPokemon: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var imageUrl: URL
    @NSManaged var genus: String
    @NSManaged var flavorText: String
    @NSManaged var timestamp: Date

    @NSManaged var abilities: NSOrderedSet
    @NSManaged var cache: ManagedDetailPokemonCache
}

extension ManagedDetailPokemon {
    static func first(with id: Int, in context: NSManagedObjectContext) -> ManagedDetailPokemon? {
        let request = NSFetchRequest<ManagedDetailPokemon>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedDetailPokemon.id), id])
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    static func delete(for id: Int, in context: NSManagedObjectContext) {
        guard let pokemon = first(with: id, in: context) else { return }
        context.delete(pokemon)
        try? context.save()
    }
    
    static func newUniqueInstance(for id: Int, in context: NSManagedObjectContext) -> ManagedDetailPokemon {
        delete(for: id, in: context)
        return ManagedDetailPokemon(context: context)
    }
    
    var local: LocalDetailPokemon {
        .init(
            info: .init(imageUrl: imageUrl, id: id, name: name, genus: genus, flavorText: flavorText),
            abilities: abilities.compactMap {
                ($0 as? ManagedDetailPokemonAbility)?.local
            }
        )
    }
}
