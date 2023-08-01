//
//  LocalPokemonListCreation.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/1/23.
//

import Pokepedia

func pokemonList() -> (local: LocalPokemonList, model: PokemonList) {
    let url = anyURL()
    let local: LocalPokemonList = [
        .init(
            id: "an id",
            name: "a name",
            imageUrl: url,
            physicalType: .init(
                color: "physical color",
                name: "name of physical color"
            ),
            specialType: .init(
                color: "special colorr",
                name: "name of special color"
            )
        )
    ]
    let model: PokemonList = [
        .init(
            id: "an id",
            name: "a name",
            imageUrl: url,
            physicalType: .init(
                color: "physical color",
                name: "name of physical color"
            ),
            specialType: .init(
                color: "special colorr",
                name: "name of special color"
            )
        )
    ]
    return (local, model)
}
