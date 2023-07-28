//
//  PokemonDetailSnapshotTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/27/23.
//

import XCTest
import Combine
import Pokepedia_iOS
import Pokepedia_iOS_App
@testable import Pokepedia

final class PokemonDetailSnapshotTests: XCTestCase {
    func test_detailInfoViewIsLoading() {
        let sut = makeSut()

        sut.display(detailInfo(isLoading: true))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_INFO_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_INFO_LOADING_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_INFO_LOADING_light_extraExtraExtraLarge")
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
    
    private func detailInfo(isLoading: Bool) -> PokemonDetailInfoStub {
        .init(
            viewModel: .init(
                imageUrl: URL(string: "http://any-url.com")!,
                id: "0034",
                name: "Nidoking",
                genus: "Drill Pokémon",
                flavorText: "It uses its powerful tail in battle to smash, constrict, then break the prey's bones."
            ),
            isLoading: true
        )
    }
}

private extension ListViewController {
    func display(_ stub: PokemonDetailInfoStub) {
        let controller = DetailPokemonInfoController(
            viewModel: stub.viewModel,
            onImageRequest: stub.didRequestImage
        )
        stub.controller = controller
        display(controllers: [CellController(id: UUID(), controller)])
    }
}


class PokemonDetailInfoStub {
    let viewModel: DetailPokemonInfoViewModel
    let image: UIImage?
    let isLoading: Bool
    weak var controller: DetailPokemonInfoController?
    
    init(
        viewModel: DetailPokemonInfoViewModel,
        image: UIImage? = nil,
        isLoading: Bool = false
    ) {
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
