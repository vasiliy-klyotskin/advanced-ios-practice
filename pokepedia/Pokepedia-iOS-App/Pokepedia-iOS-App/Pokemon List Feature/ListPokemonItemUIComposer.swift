//
//  ListPokemonItemUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 6/2/23.
//

import Pokepedia
import UIKit
import Combine
import Pokepedia_iOS

enum ListPokemonItemUIComposer {
    typealias Presetner = LoadingResourcePresenter<ListPokemonItemImage, DummyView>
    typealias PresentationAdapter = ResourceLoadingPresentationAdapter<ListPokemonItemImage, DummyView>
    
    static func compose(
        item: PokemonListItem,
        loader: @escaping () -> AnyPublisher<ListPokemonItemImage, Error>
    ) -> ListPokemonItemViewController {
        let loadingAdapter = PresentationAdapter(loader: loader)
        let controller = ListPokemonItemViewController(
            viewModel: PokemonListPresenter.map(item: item),
            onImageRequest: loadingAdapter.load
        )
        let presenter = Presetner(
            view: DummyView(),
            loadingView: WeakProxy(controller),
            errorView: DummyView()
        )
        loadingAdapter.presenter = presenter
        return controller
    }
}

struct DummyView: ResourceView, ResourceErrorView {
    func display(viewModel: Data) {
    }
    
    func display(errorViewModel: ErrorViewModel) {
    }
}
