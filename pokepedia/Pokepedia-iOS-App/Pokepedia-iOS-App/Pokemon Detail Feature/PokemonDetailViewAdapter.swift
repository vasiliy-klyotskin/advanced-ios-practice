//
//  PokemonDetailViewAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Vasiliy Klyotskin on 7/27/23.
//

import UIKit
import Pokepedia
import Pokepedia_iOS
import Combine

final class PokemonDetailViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let loader: (URL) -> AnyPublisher<DetailPokemonImage, Error>
    
    init(
        controller: ListViewController,
        loader: @escaping (URL) ->  AnyPublisher<DetailPokemonImage, Error>
    ) {
        self.controller = controller
        self.loader = loader
    }

    func display(viewModel detail: DetailPokemon) {
        let infoController = infoController(for: detail.info)
        let abilitiesTitleController = abilitiesTitle()
        let abilityControllers = abilityControllers(for: detail.abilities)
        let contentSection = [infoController, abilitiesTitleController] + abilityControllers
        controller?.display(sections: contentSection)
    }
    
    private func infoController(for model: DetailPokemonInfo) -> CellController {
        let controller = PokemonDetailInfoUIComposer.compose(model: model) { [loader] in
            loader(model.imageUrl)
        }
        return CellController(id: model, controller)
    }
    
    private func abilitiesTitle() -> CellController {
        let title = DetailPokemonPresenter.abilitiesTitle
        let controller = DefaultCellController<TitleCell> { $0.set(title: title) }
        return CellController(id: title, controller)
    }
    
    private func abilityControllers(for model: DetailPokemonAbilities) -> [CellController] {
        let viewModels = DetailPokemonPresenter.mapAbilities(model: model, colorMapping: UIColor.fromHex)
        return viewModels.map { abilityViewModel in
            let controller = DefaultCellController<DetailPokemonAbilityCell> { $0.configure(with: abilityViewModel) }
            return CellController(id: abilityViewModel, controller)
        }
    }
}
