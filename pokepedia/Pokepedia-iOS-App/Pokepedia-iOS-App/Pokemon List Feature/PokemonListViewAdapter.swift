//
//  PokemonListViewAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Vasiliy Klyotskin on 6/2/23.
//

import UIKit
import Combine
import Pokepedia
import Pokepedia_iOS

final class PokemonListViewAdapter: ResourceView {
    typealias Loader = (URL) -> AnyPublisher<ListPokemonItemImage, Error>
    typealias LoadMore = () -> AnyPublisher<Paginated<PokemonListItem>, Error>
    
    private var currentList: [PokemonListItem: CellController]
    private weak var listController: ListViewController?
    private let imageLoader: Loader
    private let onItemSelected: (PokemonListItem) -> Void
    
    init(
        listController: ListViewController,
        imageLoader: @escaping Loader,
        currentList: [PokemonListItem: CellController] = [:],
        onItemSelected: @escaping (PokemonListItem) -> Void
    ) {
        self.listController = listController
        self.imageLoader = imageLoader
        self.currentList = currentList
        self.onItemSelected = onItemSelected
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
                imageLoader: imageLoader,
                currentList: currentList,
                onItemSelected: onItemSelected
            ),
            loadMore: loadMore
        )
        return [CellController(id: UUID(), loadMoreController)]
    }
    
    private func itemsSection(for items: [PokemonListItem]) -> [CellController] {
        items.map { item in
            if let controller = currentList[item] {
                return controller
            }
            let controller = ListPokemonItemUIComposer.compose(
                item: item,
                loader: { [imageLoader] in imageLoader(item.imageUrl) },
                onSelection: { [onItemSelected] in onItemSelected(item) }
            )
            let cellController = CellController(id: item, controller)
            currentList[item] = cellController
            return cellController
        }
    }
}
