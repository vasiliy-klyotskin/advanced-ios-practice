//
//  PokemonDetailUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 7/26/23.
//

import Pokepedia_iOS
import Pokepedia
import Combine

public enum PokemonDetailUIComposer {
    typealias Presetner = LoadingResourcePresenter<DetailPokemon, DummyView>
    typealias PresentationAdapter = ResourceLoadingPresentationAdapter<DetailPokemon, DummyView>
    
    public static func compose(
        title: String,
        loader: @escaping () -> AnyPublisher<DetailPokemon, Error>
    ) -> ListViewController {
        let loadingAdapter = PresentationAdapter(loader: loader)
        let controller = ListViewController(onRefresh: loadingAdapter.load)
        let presenter = Presetner(
            view: DummyView(),
            loadingView: WeakProxy(controller),
            errorView: DummyView()
        )
        loadingAdapter.presenter = presenter
        controller.title = title
        return controller
    }
}

struct DummyView: ResourceView, ResourceErrorView, ResourceLoadingView {
    func display(errorViewModel: ErrorViewModel) {}
    func display(loadingViewModel: LoadingViewModel) {}
    func display(viewModel: DetailPokemon) {}
}
