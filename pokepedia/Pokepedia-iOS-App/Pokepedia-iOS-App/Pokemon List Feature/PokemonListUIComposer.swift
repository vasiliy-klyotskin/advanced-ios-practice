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
    typealias Presetner = LoadingResourcePresenter<PokemonList, WeakProxy<PokemonListViewController>>
    
    public static func compose(loader: @escaping () -> AnyPublisher<PokemonList, Error>) -> PokemonListViewController {
        let adapter = PokemonListLoadingAdapter(loader: loader)
        let controller = PokemonListViewController(onRefresh: adapter.load)
        let presenter = Presetner(
            view: WeakProxy(controller),
            errorView: WeakProxy(controller),
            loadingView: WeakProxy(controller),
            mapping: PokemonListPresenter.map
        )
        adapter.presenter = presenter
        controller.title = PokemonListPresenter.title
        return controller
    }
}
