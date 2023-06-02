//
//  PokemonListUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/28/23.
//

import Pokepedia
import UIKit
import Combine
import Pokepedia_iOS

public enum PokemonListUIComposer {
    typealias Presetner = LoadingResourcePresenter<PokemonList, PokemonListViewAdapter>
    
    public static func compose(
        loader: @escaping () -> AnyPublisher<PokemonList, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    ) -> PokemonListViewController {
        let loadingAdapter = PokemonListLoadingAdapter(loader: loader)
        let controller = PokemonListViewController(onRefresh: loadingAdapter.load)
        let presenter = Presetner(
            view: PokemonListViewAdapter(controller: controller, imageLoader: imageLoader),
            loadingView: WeakProxy(controller),
            errorView: WeakProxy(controller)
        )
        loadingAdapter.presenter = presenter
        controller.title = PokemonListPresenter.title
        return controller
    }
}

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
