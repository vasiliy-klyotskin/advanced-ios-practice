//
//  PokemonListFeatureComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 8/22/23.
//

import Combine
import Pokepedia
import Pokepedia_iOS
import Foundation
import CoreData

final class PokemonListFeatureComposer {
    private let pageSize = 50
    private let baseUrl: URL
    private let scheduler: AnyDispatchQueueScheduler
    private let localListLoader: LocalPokemonListLoader
    private let localListImageLoader: LocalImageLoader
    private let httpClient: HTTPClient
    
    init(
        scheduler: AnyDispatchQueueScheduler,
        baseUrl: URL,
        store: PokemonListStore & ImageStore,
        httpClient: HTTPClient
    ) {
        self.scheduler = scheduler
        self.baseUrl = baseUrl
        self.httpClient = httpClient
        self.localListLoader = .init(store: store)
        self.localListImageLoader = .init(store: store)
    }
    
    func compose(onItemSelected: @escaping (PokemonListItem) -> Void) -> ListViewController {
        PokemonListUIComposer.compose(
            loader: makePaginatedRemoteListLoaderWithLocalFallback,
            imageLoader: makeListIconLoader,
            onItemSelected: onItemSelected
        )
    }
    
    private func makeRemoteListLoader(after item: PokemonListItem? = nil) -> AnyPublisher<PokemonList, Error> {
        httpClient
            .getPublisher(request: PokemonListEndpoint.get(after: item, limit: pageSize).make(with: baseUrl))
            .tryMap(RemoteMapper<PokemonListRemote>.map)
            .tryMap(PokemonListRemoteMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makePaginatedRemoteListLoaderWithLocalFallback() -> AnyPublisher<Paginated<PokemonListItem>, Error> {
        makeRemoteListLoader()
            .caching(to: localListLoader)
            .fallback(to: localListLoader.loadPublisher)
            .map(makeFirstPage)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(list: PokemonList) -> Paginated<PokemonListItem> {
        makePage(list: list, after: list.last)
    }
    
    private func makePage(list: PokemonList, after item: PokemonListItem?) -> Paginated<PokemonListItem> {
        Paginated(items: list, loadMorePublisher: item.map { item in
            { self.makePublisherForNextPage(after: item) }
        })
    }
    
    private func makePublisherForNextPage(after item: PokemonListItem?) -> AnyPublisher<Paginated<PokemonListItem>, Error> {
        localListLoader.loadPublisher()
            .zip(makeRemoteListLoader(after: item))
            .map { ($0 + $1, $1.last) }
            .map(makePage)
            .caching(to: localListLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeListIconLoader(url: URL) -> AnyPublisher<Data, Error> {
        return localListImageLoader
            .loadImageDataPublisher(from: url)
            .fallback { [httpClient, localListImageLoader, scheduler] in
                httpClient.getPublisher(url: url)
                    .tryMap(RemoteDataMapper.map)
                    .caching(to: localListImageLoader, using: url)
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
