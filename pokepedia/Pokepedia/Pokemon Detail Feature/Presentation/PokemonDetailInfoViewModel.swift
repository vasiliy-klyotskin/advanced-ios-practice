//
//  PokemonDetailInfoViewModel.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public struct DetailPokemonViewModel<Color: Equatable>: Equatable {
    let info: DetailPokemonInfoViewModel
    let abilities: DetailPokemonAbilitiesViewModel<Color>
}

public struct DetailPokemonInfoViewModel: Equatable {
    let imageUrl: URL
    let id: String
    let name: String
    let genus: String
    let flavorText: String
}

public typealias DetailPokemonAbilitiesViewModel<Color: Equatable> = [DetailPokemonAbilityViewModel<Color>]

public struct DetailPokemonAbilityViewModel<Color: Equatable>: Equatable {
    let title: String
    let subtitle: String
    let damageClass: String
    let damageClassColor: Color
    let type: String
    let typeColor: Color
}
