//
//  ManagedDetailPokemonAbility.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import CoreData

@objc(ManagedDetailPokemonAbility)
public class ManagedDetailPokemonAbility: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var subtitle: String
    @NSManaged var damageClass: String
    @NSManaged var damageColor: String
    @NSManaged var type: String
    @NSManaged var typeColor: String
    
    @NSManaged var detail: ManagedDetailPokemon
}

extension ManagedDetailPokemonAbility {
    var local: LocalDetailPokemonAbility {
        .init(title: title, subtitle: subtitle, damageClass: damageClass, damageClassColor: damageColor, type: type, typeColor: typeColor)
    }
}
