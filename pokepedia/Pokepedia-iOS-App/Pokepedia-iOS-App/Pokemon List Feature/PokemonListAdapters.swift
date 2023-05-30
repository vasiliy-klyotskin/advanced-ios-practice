//
//  PokemonListLoadingAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/30/23.
//

import Combine
import Pokepedia
import Pokepedia_iOS

final class PokemonListLoadingAdapter {
    var presenter: LoadingResourcePresenter<Any, DummyView>?
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

extension PokemonListViewController: ResourceLoadingView {
    public func display(loadingViewModel: LoadingViewModel) {
        display(isLoading: loadingViewModel.isLoading)
    }
}

extension WeakProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(loadingViewModel: LoadingViewModel) {
        object?.display(loadingViewModel: loadingViewModel)
    }
}
