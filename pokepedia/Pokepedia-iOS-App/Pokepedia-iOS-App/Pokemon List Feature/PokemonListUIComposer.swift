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
    
    public static func compose(loader: @escaping () -> AnyPublisher<PokemonList, Error>) -> PokemonListViewController {
        let loadingAdapter = PokemonListLoadingAdapter(loader: loader)
        let controller = PokemonListViewController(onRefresh: loadingAdapter.load)
        let presenter = Presetner(
            view: PokemonListViewAdapter(controller: controller),
            loadingView: WeakProxy(controller),
            errorView: WeakProxy(controller)
        )
        loadingAdapter.presenter = presenter
        controller.title = PokemonListPresenter.title
        return controller
    }
}

final class PokemonListViewAdapter: ResourceView {
    weak var controller: PokemonListViewController?
    
    init(controller: PokemonListViewController) {
        self.controller = controller
    }

    func display(viewModel: PokemonList) {
        let controllers = PokemonListPresenter
            .map(list: viewModel)
            .map(ListPokemonItemViewController.init)
        controller?.display(controllers: controllers)
    }
}
