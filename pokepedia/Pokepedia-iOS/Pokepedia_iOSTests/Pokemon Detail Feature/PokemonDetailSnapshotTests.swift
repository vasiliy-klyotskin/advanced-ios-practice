//
//  PokemonDetailSnapshotTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/27/23.
//

import XCTest
import Combine
import Pokepedia_iOS
@testable import Pokepedia

final class PokemonDetailSnapshotTests: XCTestCase {
    func test_detailInfoViewIsInLoadingState() {
        let sut = makeSut()

        sut.display(detailInfo(isLoading: true, image: nil))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_INFO_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_INFO_LOADING_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_INFO_LOADING_light_extraExtraExtraLarge")
    }
    
    func test_detailInfoViewIsInErrorState() {
        let sut = makeSut()

        sut.display(detailInfo(isLoading: false, image: nil))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_INFO_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_INFO_ERROR_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_INFO_ERROR_light_extraExtraExtraLarge")
    }
    
    func test_detailInfoViewIsInSuccessState() {
        let sut = makeSut()
        let image = UIImage.make(withColor: .orange)
        
        sut.display(detailInfo(isLoading: false, image: image))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_INFO_IMAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_INFO_IMAGE_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_INFO_IMAGE_light_extraExtraExtraLarge")
    }
    
    func test_abilityViews() {
        let sut = makeSut()
        
        sut.display(abilities())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "POKEMON_ABILITIES_IMAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "POKEMON_ABILITIES_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "POKEMON_ABILITIES_light_extraExtraExtraLarge")
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
    
    private func detailInfo(isLoading: Bool = false, image: UIImage? = nil) -> PokemonDetailInfoStub {
        .init(
            viewModel: .init(
                imageUrl: URL(string: "http://any-url.com")!,
                id: "0034",
                name: "Nidoking",
                genus: "Drill Pokémon",
                flavorText: "It uses its powerful tail in battle to smash, constrict, then break the prey's bones."
            ),
            image: image,
            isLoading: isLoading
        )
    }
    
    private func abilities() -> DetailPokemonAbilitiesViewModel<UIColor> {
        [
            .init(
                title: "Energy Ball",
                subtitle: "The user draws power from nature and fires it at the foe. It may also lower target's Sp. Def.",
                damageClass: "FIRE",
                damageClassColor: .orange,
                type: "SPECIAL",
                typeColor: .blue
            ),
            .init(
                title: "Sword Dance",
                subtitle: "A dance that increases ATTACK.",
                damageClass: "NORMAL",
                damageClassColor: .systemPink,
                type: "STATUS",
                typeColor: .gray
            ),
            .init(
                title: "Seed Bomb",
                subtitle: "The user slams a barrage of hard-shelled seeds down on the foe from above.",
                damageClass: "GRASS",
                damageClassColor: .brown,
                type: "PHYSICAL",
                typeColor: .red
            ),
        ]
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
    
    func display(_ abilitiesViewModel: DetailPokemonAbilitiesViewModel<UIColor>) {
        let controllers = abilitiesViewModel.map {
            let controller = DetailPokemonAbilityController(viewModel: $0)
            return CellController(id: UUID(), controller)
        }
        display(controllers: controllers)
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
