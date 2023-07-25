//
//  DetailPokemon.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public struct DetailPokemon {
    public let imageUrl: URL
    public let id: String
    public let name: String
    public let genus: String
    public let flavorText: String
    
    init(imageUrl: URL, id: String, name: String, genus: String, flavorText: String) {
        self.imageUrl = imageUrl
        self.id = id
        self.name = name
        self.genus = genus
        self.flavorText = flavorText
    }
}

public struct DetailPokemonType: Equatable {
    public let color: String
    public let name: String
    
    public init(color: String, name: String) {
        self.color = color
        self.name = name
    }
}
