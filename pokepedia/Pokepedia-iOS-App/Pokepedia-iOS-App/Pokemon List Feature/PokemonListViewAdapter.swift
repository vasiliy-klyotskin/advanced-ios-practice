//
//  PokemonListViewAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit
import Combine
import Pokepedia
import Pokepedia_iOS

final class PokemonListViewAdapter: ResourceView {
    typealias Loader = (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    typealias LoadMore = () -> AnyPublisher<Paginated<PokemonListItem>, Error>
    
    private weak var listController: ListViewController?
    private let imageLoader: Loader
    
    init(listController: ListViewController, imageLoader: @escaping Loader) {
        self.listController = listController
        self.imageLoader = imageLoader
    }

    func display(viewModel paginated: Paginated<PokemonListItem>) {
        guard let listController = listController else { return }
        let itemsSection = itemsSection(for: paginated.items)
        guard let loadMore = paginated.loadMorePublisher else {
            listController.display(sections: itemsSection)
            return
        }
        let loadMoreSection = loadMoreSection(listController: listController, loadMore: loadMore)
        listController.display(sections: itemsSection, loadMoreSection)
    }
    
    private func loadMoreSection(listController: ListViewController, loadMore: @escaping LoadMore) -> [CellController] {
        let loadMoreController = LoadMorePokemonItemsUIComposer.compose(
            viewAdapter: PokemonListViewAdapter(
                listController: listController,
                imageLoader: imageLoader
            ),
            loadMore: loadMore
        )
        return [CellController(id: UUID(), loadMoreController)]
    }
    
    private func itemsSection(for items: [PokemonListItem]) -> [CellController] {
        items.map { item in
            let controller = ListPokemonItemUIComposer.compose(item: item) { [imageLoader] in
                imageLoader(item.imageUrl)
            }
            return CellController(id: item, controller)
        }
    }
}
