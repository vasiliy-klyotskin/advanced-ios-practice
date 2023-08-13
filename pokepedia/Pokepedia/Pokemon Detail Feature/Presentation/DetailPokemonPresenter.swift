//
//  DetailPokemonPresenter.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public final class DetailPokemonPresenter {
    public static var abilitiesTitle: String {
        NSLocalizedString(
            "POKEMON_DETAILS_ABILITIES_TITLE",
            tableName: "PokemonDetail",
            bundle: Bundle(for: Self.self),
            comment: "Title for abilities"
        )
    }
    
    public static func mapInfo(model: DetailPokemonInfo) -> DetailPokemonInfoViewModel {
        .init(
            imageUrl: model.imageUrl,
            id: String(format: "%04d", model.id),
            name: model.name,
            genus: model.genus,
            flavorText: model.flavorText
        )
    }
    
    public static func mapAbilities<Color>(
        model: DetailPokemonAbilities,
        colorMapping: (String) -> Color
    ) -> DetailPokemonAbilitiesViewModel<Color> {
        model.map {
            DetailPokemonAbilityViewModel(
                title: $0.title,
                subtitle: $0.subtitle,
                damageClass: $0.damageClass,
                damageClassColor: colorMapping($0.damageClassColor),
                type: $0.type,
                typeColor: colorMapping($0.typeColor)
            )
        }
    }
}
