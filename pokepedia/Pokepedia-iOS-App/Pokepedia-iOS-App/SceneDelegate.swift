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
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private let baseUrl = URL(string: "http://127.0.0.1:8080")!
    private let storeUrl = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite")
    private let pageSize = 50
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.essentialdeveloper.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var httpClient: HTTPClient = {
        let session = URLSession(configuration: .ephemeral)
        session.configuration.urlCache = nil
        let client = URLSessionHTTPClient(session: session)
        return client
    }()
    
    private lazy var store: PokemonListStore & PokemonListImageStore = {
        do {
            return try CoreDataPokemonListStore(storeUrl: storeUrl)
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return InMemoryPokemonListStore()
        }
    }()
    
    private lazy var localListLoader: LocalPokemonListLoader = {
        LocalPokemonListLoader(store: store)
    }()
    
    private lazy var localListImageLoader: LocalPokemonListImageLoader = {
        LocalPokemonListImageLoader(store: store)
    }()
    
    convenience init(
        httpClient: HTTPClient,
        store: PokemonListStore & PokemonListImageStore,
        scheduler: AnyDispatchQueueScheduler
    ) {
        self.init()
        self.httpClient = httpClient
        self.store = store
        self.scheduler = scheduler
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        try? localListLoader.validateCache()
    }
    
    func configureWindow() {
        let pokemonListVc = PokemonListUIComposer.compose(
            loader: makePaginatedRemoteListLoaderWithLocalFallback,
            imageLoader: makeListIconLoader
        )
        let navigationController = UINavigationController(rootViewController: pokemonListVc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
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
