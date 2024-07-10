//
//  PokemonDetailInfoUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Vasiliy Klyotskin on 7/27/23.
//

import Pokepedia
import Pokepedia_iOS
import Combine
import UIKit

enum PokemonDetailInfoUIComposer {
    typealias Presenter = LoadingResourcePresenter<DetailPokemonImage, WeakProxy<DetailPokemonInfoController>>
    typealias PresentationAdapter = ResourceLoadingPresentationAdapter<DetailPokemonImage, WeakProxy<DetailPokemonInfoController>>
    
    static func compose(
        model: DetailPokemonInfo,
        loader: @escaping () -> AnyPublisher<ListPokemonItemImage, Error>
    ) -> DetailPokemonInfoController {
        let loadingAdapter = PresentationAdapter(loader: loader)
        let viewModel = DetailPokemonPresenter.mapInfo(model: model)
        let controller = DetailPokemonInfoController(
            viewModel: viewModel,
            onImageRequest: loadingAdapter.load
        )
        let presenter = Presenter(
            view: WeakProxy(controller),
            errorView: WeakProxy(controller),
            loadingView: WeakProxy(controller),
            mapping: UIImage.tryFrom
        )
        loadingAdapter.presenter = presenter
        return controller
    }
}
