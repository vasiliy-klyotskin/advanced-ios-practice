//
//  PokemonListCache.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/17/23.
//

import Foundation

public protocol PokemonListCache {
    func save(_ list: PokemonList) throws
}
