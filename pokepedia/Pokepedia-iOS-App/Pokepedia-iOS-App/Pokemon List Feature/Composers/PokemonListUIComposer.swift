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
    typealias PresentationAdapter = ResourceLoadingPresentationAdapter<PokemonList, PokemonListViewAdapter>
    
    public static func compose(
        loader: @escaping () -> AnyPublisher<PokemonList, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    ) -> ListViewController {
        let loadingAdapter = PresentationAdapter(loader: loader)
        let controller = ListViewController(onRefresh: loadingAdapter.load)
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
