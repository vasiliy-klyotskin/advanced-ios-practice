//
//  PokemonDetailFeatureComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 8/22/23.
//

import Combine
import Foundation
import Pokepedia
import Pokepedia_iOS

final class PokemonDetailFeatureComposer {
    private let baseUrl: URL
    private let scheduler: AnyDispatchQueueScheduler
    private let httpClient: HTTPClient
    private let localDetailLoader: LocalDetailPokemonLoader
    private let localImageLoader: LocalImageLoader
    
    init(
        scheduler: AnyDispatchQueueScheduler,
        baseUrl: URL,
        httpClient: HTTPClient,
        store: DetailPokemonStore & ImageStore
    ) {
        self.scheduler = scheduler
        self.baseUrl = baseUrl
        self.httpClient = httpClient
        self.localDetailLoader = .init(store: store)
        self.localImageLoader = .init(store: store)
    }
    
    func compose(for listItem: PokemonListItem) -> ListViewController {
        PokemonDetailUIComposer.compose(
            title: listItem.name,
            loader: detailLoader(for: listItem),
            imageLoader: detailImageLoader()
        )
    }
    
    private func detailLoader(for listItem: PokemonListItem) -> () -> AnyPublisher<DetailPokemon, Error> {
        { [httpClient, baseUrl, scheduler, localDetailLoader] in
            httpClient
                .getPublisher(request: DetailPokemonEndpoint.get(listItem.id).make(with: baseUrl))
                .tryMap(RemoteMapper<DetailPokemonRemote>.map)
                .tryMap(DetailPokemonRemoteMapper.map)
                .caching(to: localDetailLoader)
                .fallback {
                    localDetailLoader
                        .loadPublisher(for: listItem.id)
                        .subscribe(on: scheduler)
                        .eraseToAnyPublisher()
                }
                .subscribe(on: scheduler)
                .eraseToAnyPublisher()
        }
    }
    
    private func detailImageLoader() -> (URL) -> AnyPublisher<Data, Error> {
        { [localImageLoader, scheduler, httpClient] url in
            localImageLoader
                .loadImageDataPublisher(from: url)
                .fallback {
                    httpClient.getPublisher(url: url)
                        .tryMap(RemoteDataMapper.map)
                        .caching(to: localImageLoader, using: url)
                        .subscribe(on: scheduler)
                        .eraseToAnyPublisher()
                }
                .subscribe(on: scheduler)
                .eraseToAnyPublisher()
        }
    }
}
