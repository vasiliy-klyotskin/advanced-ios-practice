//
//  PokemonListRemote.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/16/23.
//

import Foundation

public typealias PokemonListRemote = [ListPokemonItemRemote]

public struct ListPokemonItemRemote: Decodable {
    let id: String
    let name: String
    let imageUrl: URL
    let types: [ListPokemonItemTypeRemote]
}

struct ListPokemonItemTypeRemote: Decodable {
    let color: String
    let name: String
}
