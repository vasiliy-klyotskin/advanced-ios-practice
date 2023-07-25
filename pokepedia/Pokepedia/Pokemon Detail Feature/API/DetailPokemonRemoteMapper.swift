//
//  DetailPokemonRemoteMapper.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public enum DetailPokemonRemoteMapper {
    public static func map(remote: DetailPokemonRemote) -> DetailPokemon {
        let abilities = remote.abilities.map {
            DetailPokemonAbility(
                title: $0.title,
                subtitle: $0.subtitle,
                damageClass: $0.damageClass,
                damageClassColor: $0.damageClassColor,
                type: $0.type,
                typeColor: $0.typeColor
            )
        }
        return .init(
            info: .init(
                imageUrl: remote.imageUrl,
                id: remote.id,
                name: remote.name,
                genus: remote.genus,
                flavorText: remote.flavorText
            ),
            abilities: abilities
        )
    }
}
