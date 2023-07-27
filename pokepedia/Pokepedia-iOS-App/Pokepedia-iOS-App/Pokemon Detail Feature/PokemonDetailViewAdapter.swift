//
//  PokemonDetailViewAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia
import Pokepedia_iOS

final class PokemonDetailViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(viewModel detail: DetailPokemon) {
        let viewModel = DetailPokemonPresenter.map(model: detail, colorMapping: UIColor.fromHex)
        let infoController = infoController(for: viewModel.info)
        let abilityControllers = abilityControllers(for: viewModel.abilities)
        controller?.display(controllers: [infoController] + abilityControllers)
    }
    
    private func infoController(for viewModel: DetailPokemonInfoViewModel) -> CellController {
        let infoController = DetailPokemonInfoController(viewModel: viewModel)
        return CellController(id: viewModel, infoController)
    }
    
    private func abilityControllers(for viewModel: DetailPokemonAbilitiesViewModel<UIColor>) -> [CellController] {
        viewModel.map { abilityViewModel in
            let abilityController = DetailPokemonAbilityController(viewModel: abilityViewModel)
            return CellController(id: abilityViewModel, abilityController)
        }
    }
}
