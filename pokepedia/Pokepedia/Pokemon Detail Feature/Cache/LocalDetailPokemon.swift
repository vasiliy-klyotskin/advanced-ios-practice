//
//  LocalDetailPokemon.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Foundation

public struct LocalDetailPokemon: Equatable {
    public let info: LocalDetailPokemonInfo
    public let abilities: LocalDetailPokemonAbilities
    
    public init(info: LocalDetailPokemonInfo, abilities: LocalDetailPokemonAbilities) {
        self.info = info
        self.abilities = abilities
    }
}

public struct LocalDetailPokemonInfo: Equatable, Hashable {
    public let imageUrl: URL
    public let id: Int
    public let name: String
    public let genus: String
    public let flavorText: String
    
    public init(
        imageUrl: URL,
        id: Int,
        name: String,
        genus: String,
        flavorText: String
    ) {
        self.imageUrl = imageUrl
        self.id = id
        self.name = name
        self.genus = genus
        self.flavorText = flavorText
    }
}

public typealias LocalDetailPokemonAbilities = [LocalDetailPokemonAbility]

public struct LocalDetailPokemonAbility: Equatable {
    public let title: String
    public let subtitle: String
    public let damageClass: String
    public let damageClassColor: String
    public let type: String
    public let typeColor: String
    
    public init(
        title: String,
        subtitle: String,
        damageClass: String,
        damageClassColor: String,
        type: String,
        typeColor: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.damageClass = damageClass
        self.damageClassColor = damageClassColor
        self.type = type
        self.typeColor = typeColor
    }
}

extension LocalDetailPokemon {
    var model: DetailPokemon {
        .init(info: info.model, abilities: abilities.model)
    }
}

extension LocalDetailPokemonAbilities {
    var model: DetailPokemonAbilities {
        map {
            .init(title: $0.title, subtitle: $0.subtitle, damageClass: $0.damageClass, damageClassColor: $0.damageClassColor, type: $0.type, typeColor: $0.typeColor)
        }
    }
}

extension LocalDetailPokemonInfo {
    var model: DetailPokemonInfo {
        .init(imageUrl: imageUrl, id: id, name: name, genus: genus, flavorText: flavorText)
    }
}

extension DetailPokemon {
    var local: LocalDetailPokemon {
        .init(info: info.local, abilities: abilities.local)
    }
}

extension DetailPokemonAbilities {
    var local: LocalDetailPokemonAbilities {
        map {
            .init(title: $0.title, subtitle: $0.subtitle, damageClass: $0.damageClass, damageClassColor: $0.damageClassColor, type: $0.type, typeColor: $0.typeColor)
        }
    }
}

extension DetailPokemonInfo {
    var local: LocalDetailPokemonInfo {
        .init(imageUrl: imageUrl, id: id, name: name, genus: genus, flavorText: flavorText)
    }
}
