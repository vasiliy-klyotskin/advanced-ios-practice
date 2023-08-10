//
//  PokemonListUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/28/23.
//

import Pokepedia_iOS
import Pokepedia
import Combine
import UIKit

public enum PokemonListUIComposer {
    private typealias PresentationAdapter = ResourceLoadingPresentationAdapter<Paginated<PokemonListItem>, PokemonListViewAdapter>
    
    public static func compose(
        loader: @escaping () -> AnyPublisher<Paginated<PokemonListItem>, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    ) -> ListViewController {
        let loadingAdapter = PresentationAdapter(loader: loader)
        let listController = ListViewController(
            onRefresh: loadingAdapter.load,
            onViewDidLoad: PokemonListCells.register
        )
        loadingAdapter.presenter = .init(
            view: PokemonListViewAdapter(listController: listController, imageLoader: imageLoader),
            loadingView: WeakProxy(listController),
            errorView: WeakProxy(listController)
        )
        listController.title = PokemonListPresenter.title
        return listController
    }
}
