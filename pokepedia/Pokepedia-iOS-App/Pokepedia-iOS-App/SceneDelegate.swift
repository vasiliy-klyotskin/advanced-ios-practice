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
    
    private let baseUrl = URL(string: "http://0.0.0.0:8080")!
    
    private let listStoreUrl = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("list-store.sqlite")
    
    private let detailStoreUrl = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("detail-store.sqlite")
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "klyotskin.pokepedia.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private let navigationController = UINavigationController()
    
    lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: .init(configuration: .ephemeral))
    }()
    
    lazy var listStore: PokemonListStore & ImageStore = {
        do {
            return try CoreDataPokemonListStore(storeUrl: listStoreUrl)
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return InMemoryPokemonListStore()
        }
    }()
    
    lazy var detailStore: DetailPokemonStore & ImageStore = {
        do {
            return try CoreDataDetailPokemonStore(storeUrl: detailStoreUrl)
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return InMemoryDetailPokemonStore()
        }
    }()

    convenience init(
        scheduler: AnyDispatchQueueScheduler,
        listStore: PokemonListStore & ImageStore,
        detailStore: DetailPokemonStore & ImageStore,
        httpClient: HTTPClient
    ) {
        self.init()
        self.scheduler = scheduler
        self.httpClient = httpClient
        self.listStore = listStore
        self.detailStore = detailStore
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        try? LocalPokemonListLoader(store: listStore).validateCache()
        LocalDetailPokemonLoader(store: detailStore).validateCache()
    }
    
    func configureWindow() {
        let pokemonList = PokemonListFeatureComposer(
            scheduler: scheduler,
            baseUrl: baseUrl,
            store: listStore,
            httpClient: httpClient
        ).compose(onItemSelected: navigateToDetail)
        navigationController.viewControllers = [pokemonList]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func navigateToDetail(from listItem: PokemonListItem) {
        let pokemonDetail = PokemonDetailFeatureComposer(
            scheduler: scheduler,
            baseUrl: baseUrl,
            httpClient: httpClient,
            store: detailStore
        ).compose(for: listItem)
        navigationController.pushViewController(pokemonDetail, animated: true)
    }
}
