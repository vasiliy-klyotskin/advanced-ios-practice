//
//  DetailPokemonCache.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/24/23.
//

import Foundation

public protocol DetailPokemonSaveCache {
    func save(detail: DetailPokemon)
}
