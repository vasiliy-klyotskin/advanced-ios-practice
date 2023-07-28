//
//  PokemonDetailUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 7/26/23.
//

import Pokepedia_iOS
import Pokepedia
import Combine
import UIKit

public enum PokemonDetailUIComposer {
    typealias Presetner = LoadingResourcePresenter<DetailPokemon, PokemonDetailViewAdapter>
    typealias PresentationAdapter = ResourceLoadingPresentationAdapter<DetailPokemon, PokemonDetailViewAdapter>
    
    public static func compose(
        title: String,
        loader: @escaping () -> AnyPublisher<DetailPokemon, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<DetailPokemonImage, Error>
    ) -> ListViewController {
        let loadingAdapter = PresentationAdapter(loader: loader)
        let controller = ListViewController(
            onRefresh: loadingAdapter.load,
            onViewDidLoad: PokemonDetailCells.register
        )
        let presenter = Presetner(
            view: PokemonDetailViewAdapter(controller: controller, loader: imageLoader),
            loadingView: WeakProxy(controller),
            errorView: WeakProxy(controller)
        )
        loadingAdapter.presenter = presenter
        controller.title = title
        return controller
    }
}
