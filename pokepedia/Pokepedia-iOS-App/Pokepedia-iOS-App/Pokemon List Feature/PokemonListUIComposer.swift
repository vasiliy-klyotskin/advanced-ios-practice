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
    public static func compose(loader: @escaping () -> AnyPublisher<PokemonList, Error>) -> PokemonListViewController {

        let adapter = PokemonListLoadingAdapter(loader: loader)
        let controller = PokemonListViewController(onRefresh: adapter.load)
        let presenter = LoadingResourcePresenter<Any, DummyView>(
            view: DummyView(),
            errorView: DummyView(),
            loadingView: WeakProxy(controller),
            mapping: { $0 }
        )
        adapter.presenter = presenter
        controller.title = PokemonListPresenter.title
        return controller
    }
}

struct DummyView: ResourceView, ResourceErrorView {
    typealias ViewModel = Any
    func display(resourceViewModel: ViewModel) {}
    func display(errorViewModel: ErrorViewModel) {}
}
