//
//  PokemonListPresenterTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/28/23.
//

import XCTest
import Pokepedia

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
}
