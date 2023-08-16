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
        let client = URLSessionHTTPClient(session: session)
        return client
    }()
    
    private lazy var store: PokemonListStore & PokemonListImageStore = {
        InMemoryPokemonListStore()
    }()
    
    private let baseUrl = URL(string: "http://127.0.0.1:8080")!
    
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
            loader: { self.makeRemoteListLoader() },
            imageLoader: makeImageLoader
        )
        let navigationController = UINavigationController(rootViewController: pokemonListVc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func makeRemoteListLoader(after id: Int? = nil) -> AnyPublisher<Paginated<PokemonListItem>, Error> {
        httpClient
            .getPublisher(request: PokemonListEndpoint.get().make(with: baseUrl))
            .tryMap(RemoteMapper<PokemonListRemote>.map)
            .tryMap(PokemonListRemoteMapper.map)
            .map { items in
                Paginated(items: items, loadMorePublisher: (items.last?.id).map { id in { [self] in makeRemoteListLoader(after: id ) }})
            }
            .eraseToAnyPublisher()
    }
    
    private func makeImageLoader(url: URL) -> AnyPublisher<Data, Error> {
        httpClient
            .getPublisher(url: url)
            .delay(for: 3, scheduler: ImmediateScheduler.shared)
            .tryMap(RemoteDataMapper.map)
            .eraseToAnyPublisher()
    }
}
