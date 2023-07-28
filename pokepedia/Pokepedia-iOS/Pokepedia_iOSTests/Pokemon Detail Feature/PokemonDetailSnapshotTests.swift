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
        let infoController = detailInfo(controller: sut, isLoading: true, image: nil)
        
        sut.display(controllers: infoController)
        
        assertDefaultSnapshot(sut: sut, key: "POKEMON_INFO_LOADING")
    }
    
    func test_detailInfoViewIsInErrorState() {
        let sut = makeSut()
        let infoController = detailInfo(controller: sut, isLoading: false, image: nil)
        
        sut.display(controllers: infoController)
        
        assertDefaultSnapshot(sut: sut, key: "POKEMON_INFO_ERROR")
    }
    
    func test_allContent() {
        let sut = makeSut()
        let image = UIImage.make(withColor: .orange)
        let infoController = detailInfo(controller: sut, isLoading: false, image: image)
        let abilitiesTitleController = abilityTitle()
        let abilitiesControllers = abilities()
        
        sut.display(controllers: infoController + abilitiesTitleController + abilitiesControllers)
        
        assertDefaultSnapshot(sut: sut, key: "POKEMON_FULL", height: 1100)
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ListViewController {
        let sut = ListViewController(
            onRefresh: {},
            onViewDidLoad: PokemonDetailCells.register
        )
        sut.loadViewIfNeeded()
        sut.tableView.showsVerticalScrollIndicator = false
        sut.tableView.showsHorizontalScrollIndicator = false
        return sut
    }
    
    private func detailInfo(
        controller: ListViewController,
        isLoading: Bool = false,
        image: UIImage? = nil
    ) -> [CellController] {
        let stub = detailInfoStub(isLoading: isLoading, image: image)
        let controller = DetailPokemonInfoController(
            viewModel: stub.viewModel,
            onImageRequest: stub.didRequestImage
        )
        stub.controller = controller
        return [CellController(id: UUID(), controller)]
    }
    
    private func abilityTitle() -> [CellController] {
        let title = DetailPokemonPresenter.abilitiesTitle
        let controller = DefaultCellController<TitleCell> { $0.set(title: title) }
        return [CellController(id: title, controller)]
    }
    
    private func abilities() -> [CellController] {
        let controllers = abilitiesViewModels().map { viewModel in
            let controller = DefaultCellController<DetailPokemonAbilityCell> { $0.configure(with: viewModel) }
            return CellController(id: UUID(), controller)
        }
        return controllers
    }
    
    private func detailInfoStub(isLoading: Bool = false, image: UIImage? = nil) -> PokemonDetailInfoStub {
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
    
    private func abilitiesViewModels() -> DetailPokemonAbilitiesViewModel<UIColor> {
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
