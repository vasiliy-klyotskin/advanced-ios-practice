//
//  DetailPokemon.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public struct DetailPokemon: Equatable {
    let info: DetailPokemonInfo
    let abilities: DetailPokemonAbilities
}

public struct DetailPokemonInfo: Equatable {
    let imageUrl: URL
    let id: String
    let name: String
    let genus: String
    let flavorText: String
}

public typealias DetailPokemonAbilities = [DetailPokemonAbility]

public struct DetailPokemonAbility: Equatable {
    let title: String
    let subtitle: String
    let damageClass: String
    let type: String
}
