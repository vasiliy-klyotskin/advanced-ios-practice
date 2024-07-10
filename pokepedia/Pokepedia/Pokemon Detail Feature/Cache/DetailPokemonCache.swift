//
//  DetailPokemonCache.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Foundation

public struct DetailPokemonCache: Equatable {
    public let timestamp: Date
    public let local: LocalDetailPokemon
    
    public init(timestamp: Date, local: LocalDetailPokemon) {
        self.timestamp = timestamp
        self.local = local
    }
}
