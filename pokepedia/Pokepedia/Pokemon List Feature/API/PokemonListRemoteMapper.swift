//
//  PokemonListRemoteMapper.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/16/23.
//

import Foundation

public enum PokemonListRemoteMapper {
    struct MapError: Error {}
    
    public static func map(remote: PokemonListRemote) throws -> PokemonList {
        return try remote.map { item in
            guard let firstType = item.types.first else { throw MapError() }
            let secondType = item.types.count >= 2 ? item.types[1] : nil
            return .init(
                id: item.id,
                name: item.name,
                imageUrl: item.imageUrl,
                physicalType: .init(color: firstType.color, name: firstType.name),
                specialType: secondType.map { .init(color: $0.color, name: $0.name) }
            )
        }
    }
}
