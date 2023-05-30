//
//  PokemonListUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/28/23.
//

import Pokepedia
import UIKit
import Combine
import Pokepedia_iOS

struct Null: ResourceView, ResourceErrorView {
    typealias ViewModel = Any
    func display(resourceViewModel: ViewModel) {}
    func display(errorViewModel: ErrorViewModel) {}
}

typealias Presenter = LoadingResourcePresenter<Any, Null>

public enum PokemonListUIComposer {
    public static func compose(loader: @escaping () -> AnyPublisher<PokemonList, Error>) -> PokemonListViewController {

        let adapter = PokemonListLoadingAdapter(loader: loader)
        let controller = PokemonListViewController(onRefresh: adapter.load)
        let presenter = Presenter(
            view: Null(),
            errorView: Null(),
            loadingView: WeakProxy(controller),
            mapping: { $0 }
        )
        adapter.presenter = presenter
        controller.title = PokemonListPresenter.title
        return controller
    }
}

final class WeakProxy<T: AnyObject> {
    weak var object: T?
    
    init(_ object: T?) {
        self.object = object
    }
}

extension WeakProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(loadingViewModel: LoadingViewModel) {
        object?.display(loadingViewModel: loadingViewModel)
    }
}

extension PokemonListViewController: ResourceLoadingView {
    public func display(loadingViewModel: LoadingViewModel) {
        display(isLoading: loadingViewModel.isLoading)
    }
}

final class PokemonListLoadingAdapter {
    var presenter: Presenter?
    private let loader: () -> AnyPublisher<PokemonList, Error>
    private var cancellable: AnyCancellable?
    private var isLoading = false
    
    init(loader: @escaping () -> AnyPublisher<PokemonList, Error>) {
        self.loader = loader
    }
    
    func load() {
        guard !isLoading else { return }
        presenter?.didStartLoading()
        isLoading = true
        cancellable = loader().sink(
            receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.presenter?.didFinishLoadingWithError()
                }
                self?.isLoading = false
            },
            receiveValue: { [weak self] _ in
                self?.presenter?.didFinishLWithResource("")
            }
        )
    }
}
