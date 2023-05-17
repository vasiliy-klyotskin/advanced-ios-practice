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
        for item in remote {
            guard let firstType = item.types.first else { throw MapError() }
        }
        return []
        
//        return try remote.map { pokemon in
//            guard let firstType = pokemon.types.first else { throw RemoteError() }
//            let secondType = pokemon.types.count >= 2 ? pokemon.types[1] : nil
//            return .init(
//                id: pokemon.id,
//                name: pokemon.name,
//                iconUrl: pokemon.imageUrl,
//                physicalType: .init(color: firstType.color, name: firstType.name),
//                specialType: secondType.map { .init(color: $0.color, name: $0.name) }
//            )
//        }
    }
}
