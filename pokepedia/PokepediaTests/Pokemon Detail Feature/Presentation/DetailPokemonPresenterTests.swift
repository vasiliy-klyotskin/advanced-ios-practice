//
//  DetailPokemonPresenterTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/25/23.
//

import XCTest
@testable import Pokepedia

final class DetailPokemonPresenterTests: XCTestCase {
    func test_map_deliversDetailPokemonViewModel() {
        let (viewModel, model) = makeItem()
        
        let result = DetailPokemonPresenter.map(model: model, colorMapping: Color.init)
        
        XCTAssertEqual(viewModel, result)
    }
    
    // MARK: - Helpers
    
    private func makeItem() -> (DetailPokemonViewModel<Color>, DetailPokemon) {
        let imageUrl = anyURL()
        let viewModel = DetailPokemonViewModel<Color>(
            info: .init(
                imageUrl: imageUrl,
                id: "id",
                name: "name",
                genus: "genus",
                flavorText: "flavorText"
            ),
            abilities: [
                .init(
                    title: "title",
                    subtitle: "subtitle",
                    damageClass: "class",
                    damageClassColor: Color(value: "class color"),
                    type: "type",
                    typeColor: Color(value: "type color")
                )
            ]
        )
        
        let model = DetailPokemon(
            info: .init(
                imageUrl: imageUrl,
                id: "id",
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
        return (viewModel, model)
    }
    
    private struct Color: Equatable {
        let value: String
    }
}
