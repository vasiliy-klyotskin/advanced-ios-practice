//
//  LocalPokemonListCreation.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/1/23.
//

import Pokepedia

func pokemonList() -> (local: LocalPokemonList, model: PokemonList) {
    let url = anyURL()
    let local: LocalPokemonList = [
        .init(
            id: 1,
            name: "a name",
            imageUrl: url,
            physicalType: .init(
                color: "physical color",
                name: "name of physical color"
            ),
            specialType: .init(
                color: "special color",
                name: "name of special color"
            )
        )
    ]
    let model: PokemonList = [
        .init(
            id: 1,
            name: "a name",
            imageUrl: url,
            physicalType: .init(
                color: "physical color",
                name: "name of physical color"
            ),
            specialType: .init(
                color: "special color",
                name: "name of special color"
            )
        )
    ]
    return (local, model)
}
