//
//  DetailPokemonRemoteMapperTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/25/23.
//

import XCTest
@testable import Pokepedia

final class DetailPokemonRemoteMapperTests: XCTestCase {
    func test_map_deliversDetailPokemon() {
        let (remote, model) = makeItem()
        
        let result = DetailPokemonRemoteMapper.map(remote: remote)
        
        XCTAssertEqual(model, result)
    }
    
    // MARK: - Helpers
    
    private func makeItem() -> (DetailPokemonRemote, DetailPokemon) {
        let imageUrl = anyURL()
        let remote: DetailPokemonRemote = .init(
            imageUrl: imageUrl,
            id: 1,
            name: "name",
            genus: "genus",
            flavorText: "flavorText",
            abilities: [
                .init(
                    title: "title",
                    subtitle: "subtitle",
                    damageClass: "class",
                    damageClassColor: "class color",
                    type: "type",
                    typeColor: "type color"
                )
            ]
        )
        
        let model: DetailPokemon = .init(
            info: .init(
                imageUrl: imageUrl,
                id: 1,
                name: "name",
                genus: "genus",
                flavorText: "flavorText"
            ),
            abilities: [
                .init(
                    title: "title",
                    subtitle: "subtitle",
                    damageClass: "class",
                    damageClassColor: "class color",
                    type: "type",
                    typeColor: "type color"
                )
            ]
        )
        return (remote, model)
    }
}
