//
//  PokemonListSnapshotTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/12/23.
//

import XCTest
import Combine
import Pokepedia
import Pokepedia_iOS
import Pokepedia_iOS_App

final class PokemonListSnapshotTests: XCTestCase {
    
    func test_listIsLoadingSnapshot() {
        let (sut, _) = makeSut()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_LIST_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_LIST_LOADING_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_LIST_LOADING_light_extraExtraExtraLarge")
    }
    
    func test_listLoadedWithErrorSnapshot() {
        let (sut, loader) = makeSut()
        
        loader.completeListLoadingWithError(at: 0)
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_LIST_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_LIST_ERROR_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_LIST_ERROR_light_extraExtraExtraLarge")
    }
    
    func test_listLoadedWithSuccess() {
        let (sut, loader) = makeSut()
        
        loader.completeListLoading(with: makeList(), at: 0)
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_LIST_SUCCESS_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_LIST_SUCCESS_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_LIST_SUCCESS_light_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (PokemonListViewController, PokemonListMockLoader) {
        let mock = PokemonListMockLoader()
        let sut = PokemonListUIComposer.compose(
            loader: mock.load,
            imageLoader: mock.loadImage
        )
        sut.loadViewIfNeeded()
        sut.tableView.showsVerticalScrollIndicator = false
        sut.tableView.showsHorizontalScrollIndicator = false
        return (sut, mock)
    }
    
    private func makeList() -> PokemonList {
        [
            .init(
                id: "1007",
                name: "Koraidon",
                imageUrl: anyURL(),
                physicalType: .init(
                    color: "CC0066",
                    name: "Dragon"
                ),
                specialType: .init(
                    color: "CC0000",
                    name: "Fighting"
                )
            ),
            .init(
                id: "0004",
                name: "Charmander",
                imageUrl: anyURL(),
                physicalType: .init(
                    color: "FF8000",
                    name: "Fire"
                ),
                specialType: nil
            ),
            .init(
                id: "9999",
                name: "Some Pokemon with very loooong name",
                imageUrl: anyURL(),
                physicalType: .init(
                    color: "CCAB18",
                    name: "Electric"
                ),
                specialType: .init(
                    color: "4C2FAD",
                    name: "Poison"
                )
            )
        ]
    }
}
