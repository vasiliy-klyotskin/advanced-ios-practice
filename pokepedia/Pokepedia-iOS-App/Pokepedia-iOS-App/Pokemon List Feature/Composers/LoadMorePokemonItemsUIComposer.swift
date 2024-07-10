//
//  LoadMorePokemonItemsUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Vasiliy Klyotskin on 8/9/23.
//

import Combine
import Pokepedia_iOS
import Pokepedia

enum LoadMorePokemonItemsUIComposer {
    private typealias LoadMorePresentationAdapter = ResourceLoadingPresentationAdapter<Paginated<PokemonListItem>, PokemonListViewAdapter>

    static func compose(
        viewAdapter: PokemonListViewAdapter,
        loadMore: @escaping () -> AnyPublisher<Paginated<PokemonListItem>, Error>
    ) -> LoadMoreCellController {
        let presentationAdapter = LoadMorePresentationAdapter(loader: loadMore)
        let controller = LoadMoreCellController(callback: presentationAdapter.load)
        presentationAdapter.presenter = .init(
            view: viewAdapter,
            loadingView: WeakProxy(controller),
            errorView: WeakProxy(controller)
        )
        return controller
    }
}
