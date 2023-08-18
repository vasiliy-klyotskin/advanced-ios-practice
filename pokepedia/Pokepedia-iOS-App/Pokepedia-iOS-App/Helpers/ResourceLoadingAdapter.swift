//
//  ResourceLoadingAdapter.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 6/2/23.
//

import Combine
import Pokepedia

final class ResourceLoadingPresentationAdapter<Resource, View: ResourceView> {
    var presenter: LoadingResourcePresenter<Resource, View>?
    
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: AnyCancellable?
    private var isLoading = false
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func load() {
        guard !isLoading else { return }
        presenter?.didStartLoading()
        isLoading = true
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(
            receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.presenter?.didFinishLoadingWithError()
                }
                self?.isLoading = false
            },
            receiveValue: { [weak self] list in
                self?.presenter?.didFinishLWithResource(list)
            }
        )
    }
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
