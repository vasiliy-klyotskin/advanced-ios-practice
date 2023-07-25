//
//  DetailPokemonPresenter.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public enum DetailPokemonPresenter {
    public static func map(model: DetailPokemon) -> DetailPokemonViewModel {
        let abilities = model.abilities.map {
            DetailPokemonAbilityViewModel(
                title: $0.title,
                subtitle: $0.subtitle,
                damageClass: $0.damageClass,
                type: $0.type
            )
        }
        return .init(
            info: .init(
                imageUrl: model.info.imageUrl,
                id: model.info.id,
                name: model.info.name,
                genus: model.info.genus,
                flavorText: model.info.flavorText
            ),
            abilities: abilities
        )
    }
}
