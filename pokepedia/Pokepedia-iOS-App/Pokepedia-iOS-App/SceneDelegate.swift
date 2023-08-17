//
//  SceneDelegate.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/26/23.
//

import UIKit
import Pokepedia_iOS
import Pokepedia
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        session.configuration.urlCache = nil
        let client = URLSessionHTTPClient(session: session)
        return client
    }()
    
    private lazy var store: PokemonListStore & PokemonListImageStore = {
        InMemoryPokemonListStore()
    }()
    
    private let baseUrl = URL(string: "http://127.0.0.1:8080")!
    
    private lazy var localListLoader: LocalPokemonListLoader = {
        LocalPokemonListLoader(store: store)
    }()
    
    convenience init(
        httpClient: HTTPClient,
        store: PokemonListStore & PokemonListImageStore
    ) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let pokemonListVc = PokemonListUIComposer.compose(
            loader: makePaginatedRemoteListLoaderWithLocalFallback,
            imageLoader: makeImageLoader
        )
        let navigationController = UINavigationController(rootViewController: pokemonListVc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func makeRemoteListLoader(after item: PokemonListItem? = nil) -> AnyPublisher<PokemonList, Error> {
        httpClient
            .getPublisher(request: PokemonListEndpoint.get(after: item).make(with: baseUrl))
            .tryMap(RemoteMapper<PokemonListRemote>.map)
            .tryMap(PokemonListRemoteMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makePaginatedRemoteListLoaderWithLocalFallback() -> AnyPublisher<Paginated<PokemonListItem>, Error> {
        makeRemoteListLoader()
            .caching(to: localListLoader)
            .fallback(to: localListLoader.loadPublisher)
            .map(makeFirstPage)
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
            .eraseToAnyPublisher()
    }
    
    private func makeImageLoader(url: URL) -> AnyPublisher<Data, Error> {
        httpClient
            .getPublisher(url: url)
            .tryMap(RemoteDataMapper.map)
            .eraseToAnyPublisher()
    }
}
