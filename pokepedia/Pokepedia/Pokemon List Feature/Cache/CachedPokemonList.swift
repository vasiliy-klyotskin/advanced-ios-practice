//
//  CachedPokemonList.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/3/23.
//

import Foundation

public struct CachedPokemonList {
    public let local: LocalPokemonList
    public let timestamp: Date
    
    public init(local: LocalPokemonList, timestamp: Date) {
        self.local = local
        self.timestamp = timestamp
    }
}
