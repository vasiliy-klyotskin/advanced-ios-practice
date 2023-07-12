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
}
