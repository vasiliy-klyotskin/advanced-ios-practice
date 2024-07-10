//
//  File.swift
//  
//
//  Created by Василий Клецкин on 8/23/23.
//

import Foundation

final class PokemonDetailTestData {
    static let data: DetailPokemonDTO = .init(
        imageUrl: URL(string: "http://detail-image-0.com")!,
        id: 0,
        name: "name",
        genus: "genus",
        flavorText: "flavor",
        abilities: [
            .init(
                title: "title",
                subtitle: "subtitle",
                damageClass: "damage",
                damageClassColor: "damageColor",
                type: "type",
                typeColor: "typeColor"
            )
        ]
    )
}
