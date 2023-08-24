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
    
    init(
        scheduler: AnyDispatchQueueScheduler,
        baseUrl: URL,
        httpClient: HTTPClient
    ) {
        self.scheduler = scheduler
        self.baseUrl = baseUrl
        self.httpClient = httpClient
    }
    
    func compose(for listItem: PokemonListItem) -> ListViewController {
        PokemonDetailUIComposer.compose(
            title: listItem.name,
            loader: detailLoader(for: listItem),
            imageLoader: detailImageLoader()
        )
    }
    
    private func detailLoader(for listItem: PokemonListItem) -> () -> AnyPublisher<DetailPokemon, Error> {
        { [httpClient, baseUrl, scheduler] in
            httpClient
                .getPublisher(request: DetailPokemonEndpoint.get(listItem.id).make(with: baseUrl))
                .tryMap(RemoteMapper<DetailPokemonRemote>.map)
                .tryMap(DetailPokemonRemoteMapper.map)
                .subscribe(on: scheduler)
                .eraseToAnyPublisher()
        }
    }
    
    private func detailImageLoader() -> (URL) -> AnyPublisher<Data, Error> {
        { [httpClient, scheduler] url in
            httpClient.getPublisher(url: url)
                .tryMap(RemoteDataMapper.map)
                .subscribe(on: scheduler)
                .eraseToAnyPublisher()
        }
    }
}
