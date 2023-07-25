//
//  PokemonDetailInfoViewModel.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public struct DetailPokemonViewModel: Equatable {
    let info: DetailPokemonInfoViewModel
    let abilities: DetailPokemonAbilitiesViewModel
}

public struct DetailPokemonInfoViewModel: Equatable {
    let imageUrl: URL
    let id: String
    let name: String
    let genus: String
    let flavorText: String
}

public typealias DetailPokemonAbilitiesViewModel = [DetailPokemonAbilityViewModel]

public struct DetailPokemonAbilityViewModel: Equatable {
    let title: String
    let subtitle: String
    let damageClass: String
    let type: String
}
