//
//  PokemonDetailViewAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia
import Pokepedia_iOS
import Combine

final class PokemonDetailViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let loader: (URL) -> AnyPublisher<DetailPokemonImage, Error>
    
    init(controller: ListViewController, loader: @escaping (URL) ->  AnyPublisher<DetailPokemonImage, Error>) {
        self.controller = controller
        self.loader = loader
    }

    func display(viewModel detail: DetailPokemon) {
        let infoController = infoController(for: detail.info)
        let abilityControllers = abilityControllers(for: detail.abilities)
        controller?.display(controllers: [infoController] + abilityControllers)
    }
    
    private func infoController(for model: DetailPokemonInfo) -> CellController {
        let controller = PokemonDetailInfoUIComposer.compose(model: model) { [loader] in
            loader(model.imageUrl)
        }
        return CellController(id: model, controller)
    }
    
    private func abilityControllers(for model: DetailPokemonAbilities) -> [CellController] {
        let viewModels = DetailPokemonPresenter.mapAbilities(model: model, colorMapping: UIColor.fromHex)
        return viewModels.map { abilityViewModel in
            let controller = DetailPokemonAbilityController(viewModel: abilityViewModel)
            return CellController(id: abilityViewModel, controller)
        }
    }
}
