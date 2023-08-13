//
//  PokemonListRemote.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/16/23.
//

import Foundation

public typealias PokemonListRemote = [ListPokemonItemRemote]

public struct ListPokemonItemRemote: Decodable {
    let id: Int
    let name: String
    let iconUrl: URL
    let physicalType: ListPokemonTypeRemote
    let specialType: ListPokemonTypeRemote?
}

public struct ListPokemonTypeRemote: Decodable {
    let color: String
    let name: String
}
