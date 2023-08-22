//
//  DetailPokemonValidationRetrieval.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/22/23.
//

import Foundation

public struct DetailPokemonValidationRetrieval {
    public let timestamp: Date
    public let id: Int
    
    public init(timestamp: Date, id: Int) {
        self.timestamp = timestamp
        self.id = id
    }
}
