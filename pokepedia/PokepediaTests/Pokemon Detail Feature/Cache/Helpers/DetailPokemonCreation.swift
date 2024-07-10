//
//  DetailPokemonCreation.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Foundation
import Pokepedia

func localDetail(for id: Int) -> (model: DetailPokemon, local: LocalDetailPokemon) {
    let model: DetailPokemon = .init(
        info: .init(
            imageUrl: URL(string: "http://detail-\(id).com")!,
            id: id,
            name: "name \(id)",
            genus: "genus \(id)",
            flavorText: "flavor \(id)"
        ),
        abilities: [.init(
            title: "titile \(id)",
            subtitle: "subtitle \(id)",
            damageClass: "damage \(id)",
            damageClassColor: "damage color \(id)",
            type: "type \(id)",
            typeColor: "type color \(id)"
        )]
    )
    let local: LocalDetailPokemon = .init(
        info: .init(
            imageUrl: URL(string: "http://detail-\(id).com")!,
            id: id,
            name: "name \(id)",
            genus: "genus \(id)",
            flavorText: "flavor \(id)"
        ),
        abilities: [.init(
            title: "titile \(id)",
            subtitle: "subtitle \(id)",
            damageClass: "damage \(id)",
            damageClassColor: "damage color \(id)",
            type: "type \(id)",
            typeColor: "type color \(id)"
        )]
    )
    return (model, local)
}
