//
//  LocalPokemonList.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/31/23.
//

import Foundation

struct LocalPokemonList {
    let items: LocalPokemonListItem
    let timestamp: Date
}

struct LocalPokemonListItem {
    let id: String
    let name: String
    let imageUrl: URL
    let physicalType: LocalPokemonListItemType
    let specialType: LocalPokemonListItemType?
}

struct LocalPokemonListItemType {
    let color: String
    let name: String
}
