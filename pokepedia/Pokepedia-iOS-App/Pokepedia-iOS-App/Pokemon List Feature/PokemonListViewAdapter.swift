//
//  PokemonListViewAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit
import Combine
import Pokepedia
import Pokepedia_iOS

final class PokemonListViewAdapter: ResourceView {
    private weak var controller: PokemonListViewController?
    private let imageLoader: (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    
    init(
        controller: PokemonListViewController,
        imageLoader: @escaping (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    ) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(viewModel list: PokemonList) {
        controller?.display(controllers: controllers(from: list))
    }
    
    private func controllers(from list: PokemonList) -> [ListPokemonItemViewController] {
        list.map { item in
            let viewModel = PokemonListPresenter.map(item: item)
            let controller = ListPokemonItemViewController(viewModel: viewModel) {
                _ = self.imageLoader(item.imageUrl)
            }
            return controller
        }
    }
}
