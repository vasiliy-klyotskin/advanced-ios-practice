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
    typealias Loader = (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    
    private weak var controller: PokemonListViewController?
    private let imageLoader: Loader
    
    init(controller: PokemonListViewController, imageLoader: @escaping Loader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(viewModel list: PokemonList) {
        controller?.display(controllers: list.map(itemController))
    }
    
    private func itemController(for item: PokemonListItem) -> ListPokemonItemViewController {
        ListPokemonItemUIComposer.compose(item: item) { [imageLoader] in
            imageLoader(item.imageUrl)
        }
    }
}
