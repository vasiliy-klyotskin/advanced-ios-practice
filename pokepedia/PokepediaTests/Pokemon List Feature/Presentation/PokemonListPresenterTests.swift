//
//  PokemonListPresenterTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/28/23.
//

import XCTest
@testable import Pokepedia

final class PokemonListPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        let expected = localized(
            "POKEMON_LIST_TITLE",
            table: "PokemonList",
            bundleType: PokemonListPresenter.self
        )
        
        let actual = PokemonListPresenter.title
        
        XCTAssertEqual(actual, expected)
    }
    
    func test_map_deliversViewModel() {
        let (viewModel, model) = makeItem()
        
        let result = PokemonListPresenter.map(item: model, colorMapping: Color.init)
        
        XCTAssertEqual(result, viewModel)
    }
    
    // MARK: - Helpers
    
    private func makeItem() -> (ListPokemonItemViewModel<Color>, PokemonListItem) {
        let viewModel = ListPokemonItemViewModel<Color>(
            name: "some name",
            id: "0001",
            physicalType: "some physical type",
            specialType: "some special type",
            physicalTypeColor: Color(value: "some physical color"),
            specialTypeColor: Color(value: "some special color")
        )
        let model = PokemonListItem(
            id: 1,
            name: "some name",
            imageUrl: anyURL(),
            physicalType: .init(
                color: "some physical color",
                name: "some physical type"
            ),
            specialType: .init(
                color: "some special color",
                name: "some special type")
        )
        
        return (viewModel, model)
    }
    
    private struct Color: Hashable {
        let value: String
    }
}
