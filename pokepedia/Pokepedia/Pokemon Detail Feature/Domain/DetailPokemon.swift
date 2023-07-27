//
//  DetailPokemon.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public struct DetailPokemon: Equatable {
    public let info: DetailPokemonInfo
    public let abilities: DetailPokemonAbilities
    
    public init(info: DetailPokemonInfo, abilities: DetailPokemonAbilities) {
        self.info = info
        self.abilities = abilities
    }
}

public struct DetailPokemonInfo: Equatable, Hashable {
    public let imageUrl: URL
    public let id: String
    public let name: String
    public let genus: String
    public let flavorText: String
    
    public init(imageUrl: URL, id: String, name: String, genus: String, flavorText: String) {
        self.imageUrl = imageUrl
        self.id = id
        self.name = name
        self.genus = genus
        self.flavorText = flavorText
    }
}

public typealias DetailPokemonAbilities = [DetailPokemonAbility]

public struct DetailPokemonAbility: Equatable {
    public let title: String
    public let subtitle: String
    public let damageClass: String
    public let damageClassColor: String
    public let type: String
    public let typeColor: String
    
    public init(title: String, subtitle: String, damageClass: String, damageClassColor: String, type: String, typeColor: String) {
        self.title = title
        self.subtitle = subtitle
        self.damageClass = damageClass
        self.damageClassColor = damageClassColor
        self.type = type
        self.typeColor = typeColor
    }
}
