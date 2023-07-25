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
        
        let result = DetailPokemonPresenter.map(model: model)
        
        XCTAssertEqual(viewModel, result)
    }
    
    // MARK: - Helpers
    
    private func makeItem() -> (DetailPokemonViewModel, DetailPokemon) {
        let imageUrl = anyURL()
        let viewModel = DetailPokemonViewModel(
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
                    type: "type"
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
                    type: "type"
                )
            ]
        )
        return (viewModel, model)
    }
}
