//
//  PokemonListUIIntegrationTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/28/23.
//

import XCTest
import UIKit
import Pokepedia_iOS_App
import Pokepedia

final class PokemonListUIIntegrationTests: XCTestCase {
    func test_pokemonList_hasTitle() throws {
        let (sut, _) = makeSut()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, pokemonListTitle)
    }
    
    // MARK: - Helpers
    
    private func makeSut() -> (UIViewController, MockLoader) {
        let loader = MockLoader()
        let sut = PokemonListUIComposer.compose()
        return (sut, loader)
    }
    
    private var pokemonListTitle: String {
        PokemonListPresenter.title
    }
    
    private final class MockLoader {}
}
