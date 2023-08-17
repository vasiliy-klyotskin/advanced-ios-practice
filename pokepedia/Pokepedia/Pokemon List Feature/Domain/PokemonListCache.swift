//
//  PokemonListCache.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/17/23.
//

import Foundation

public protocol PokemonListCache {
    func save(_ list: PokemonList) throws
}
