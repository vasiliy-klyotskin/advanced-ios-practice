//
//  LocalPokemonList.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 7/31/23.
//

import Foundation

public typealias LocalPokemonList = [LocalPokemonListItem]

public struct LocalPokemonListItem: Equatable {
    public let id: Int
    public let name: String
    public let imageUrl: URL
    public let physicalType: LocalPokemonListItemType
    public let specialType: LocalPokemonListItemType?
    
    public init(
        id: Int,
        name: String,
        imageUrl: URL,
        physicalType: LocalPokemonListItemType,
        specialType: LocalPokemonListItemType?
    ) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.physicalType = physicalType
        self.specialType = specialType
    }
}

public struct LocalPokemonListItemType: Equatable {
    public let color: String
    public let name: String
    
    public init(color: String, name: String) {
        self.color = color
        self.name = name
    }
}

extension LocalPokemonList {
    var model: PokemonList {
        map {
            .init(
                id: $0.id,
                name: $0.name,
                imageUrl: $0.imageUrl,
                physicalType: .init(color: $0.physicalType.color, name: $0.physicalType.name),
                specialType: $0.specialType.map { .init(color: $0.color, name: $0.name) }
            )
        }
    }
}

extension PokemonList {
    var local: LocalPokemonList {
        map {
            .init(
                id: $0.id,
                name: $0.name,
                imageUrl: $0.imageUrl,
                physicalType: .init(color: $0.physicalType.color, name: $0.physicalType.name),
                specialType: $0.specialType.map { .init(color: $0.color, name: $0.name) }
            )
        }
    }
}
