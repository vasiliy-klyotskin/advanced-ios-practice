//
//  PokemonListSnapshotTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/12/23.
//

import XCTest
import Combine
import Pokepedia_iOS
@testable import Pokepedia

final class PokemonListSnapshotTests: XCTestCase {
    func test_listLoadedWithSuccess() {
        let sut = makeSut()

        sut.display(listWithLoadedContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_LIST_SUCCESS_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_LIST_SUCCESS_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_LIST_SUCCESS_light_extraExtraExtraLarge")
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ListViewController {
        let sut = ListViewController(onRefresh: {})
        sut.loadViewIfNeeded()
        sut.tableView.showsVerticalScrollIndicator = false
        sut.tableView.showsHorizontalScrollIndicator = false
        return sut
    }
    
    private func listWithLoadedContent() -> [PokemonListItemStub] {
        [
            .init(viewModel: pokemonWithSpecialType, image: UIImage.make(withColor: .brown)),
            .init(viewModel: pokemonWithoutSpecialType, image: nil),
            .init(viewModel: pokemonWithLongName, isLoading: true)
        ]
    }
    
    private var pokemonWithSpecialType: ListPokemonItemViewModel<UIColor> {
        .init(
            name: "Koraidon",
            id: "0005",
            physicalType: "Fighting",
            specialType: "Dragon",
            physicalTypeColor: .red,
            specialTypeColor: .purple
        )
    }
    
    private var pokemonWithoutSpecialType: ListPokemonItemViewModel<UIColor> {
        .init(
            name: "Charmander",
            id: "0003",
            physicalType: "Fire",
            specialType: nil,
            physicalTypeColor: .orange,
            specialTypeColor: nil
        )
    }
    
    private var pokemonWithLongName: ListPokemonItemViewModel<UIColor> {
        .init(
            name: "Some Pokemon with very loooong name",
            id: "0007",
            physicalType: "Fighting",
            specialType: "Dragon",
            physicalTypeColor: .red,
            specialTypeColor: .purple
        )
    }
}

private extension ListViewController {
    func display(_ stubs: [PokemonListItemStub]) {
        let controllers = stubs.map { stub in
            let controller = ListPokemonItemViewController(
                viewModel: stub.viewModel,
                onImageRequest: stub.didRequestImage
            )
            stub.controller = controller
            return CellController(id: UUID(), controller)
        }
        
        display(controllers: controllers)
    }
}


class PokemonListItemStub {
    let viewModel: ListPokemonItemViewModel<UIColor>
    let image: UIImage?
    let isLoading: Bool
    weak var controller: ListPokemonItemViewController?
    
    init(viewModel: ListPokemonItemViewModel<UIColor>, image: UIImage? = nil, isLoading: Bool = false) {
        self.viewModel = viewModel
        self.image = image
        self.isLoading = isLoading
    }
    
    func didRequestImage() {
        if isLoading {
            controller?.display(loadingViewModel: .init(isLoading: true))
            return
        }
        controller?.display(loadingViewModel: .init(isLoading: false))
        if let image = image {
            controller?.display(viewModel: image)
            controller?.display(errorViewModel: .init(errorMessage: nil))
        } else {
            controller?.display(errorViewModel: .init(errorMessage: "any"))
        }
    }
}
