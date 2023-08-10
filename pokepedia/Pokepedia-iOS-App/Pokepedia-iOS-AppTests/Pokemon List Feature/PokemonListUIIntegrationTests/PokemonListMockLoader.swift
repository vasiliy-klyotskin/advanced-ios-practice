//
//  PokemonListMockLoader.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/12/23.
//

import UIKit
import Combine
import Pokepedia

final class PokemonListMockLoader {
    // MARK: - Load List
    
    var loadListCallCount: Int { listRequests.count }
    var listRequests = [PassthroughSubject<Paginated<PokemonListItem>, Error>]()
    
    func load() -> AnyPublisher<Paginated<PokemonListItem>, Error> {
        let request = PassthroughSubject<Paginated<PokemonListItem>, Error>()
        listRequests.append(request)
        return request.eraseToAnyPublisher()
    }
    
    func completeListLoading(with list: PokemonList = [], at index: Int) {
        let paginated = Paginated(items: list) { [weak self] in
            self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
        }
        listRequests[index].send(paginated)
        listRequests[index].send(completion: .finished)
    }
    
    func completeListLoadingWithError(at index: Int) {
        listRequests[index].send(completion: .failure(anyNSError()))
    }
    
    // MARK: - Load More
    
    private var loadMoreRequests = [PassthroughSubject<Paginated<PokemonListItem>, Error>]()
    
    var loadMoreCallCount: Int {
        return loadMoreRequests.count
    }
    
    func loadMorePublisher() -> AnyPublisher<Paginated<PokemonListItem>, Error> {
        let publisher = PassthroughSubject<Paginated<PokemonListItem>, Error>()
        loadMoreRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }
    
    func completeLoadMore(with list: PokemonList = [], lastPage: Bool = false, at index: Int = 0) {
        loadMoreRequests[index].send(
            Paginated(
                items: list,
                loadMorePublisher: lastPage ? nil : { [weak self] in
                    self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
                }
            )
        )
    }
    
    func completeLoadMoreWithError(at index: Int = 0) {
        loadMoreRequests[index].send(completion: .failure(anyNSError()))
    }
    
    // MARK: - Load Image
    
    var imageUrls = [URL]()
    var imageRequests = [PassthroughSubject<ListPokemonItemImage, Error>]()
    
    func loadImage(for url: URL) -> AnyPublisher<ListPokemonItemImage, Error> {
        let request = PassthroughSubject<ListPokemonItemImage, Error>()
        imageUrls.append(url)
        imageRequests.append(request)
        return request.eraseToAnyPublisher()
    }
    
    func completeImageLoading(with image: ListPokemonItemImage? = nil, at index: Int) {
        let defaultImage = UIImage.make(withColor: .blue).pngData()!
        imageRequests[index].send(image ?? defaultImage)
        imageRequests[index].send(completion: .finished)
    }
    
    func completeImageLoadingWithError(at index: Int) {
        imageRequests[index].send(completion: .failure(anyNSError()))
    }
}
