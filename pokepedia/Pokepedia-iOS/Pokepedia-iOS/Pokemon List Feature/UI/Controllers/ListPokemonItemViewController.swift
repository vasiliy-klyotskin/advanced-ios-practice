//
//  ListPokemonItemViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit
import Pokepedia

public final class ListPokemonItemViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: ListPokemonItemViewModel<UIColor>
    private let onImageRequest: () -> Void
    private let onCancelRequest: () -> Void
    
    private var cell: ListPokemonItemCell?
    
    public init(
        viewModel: ListPokemonItemViewModel<UIColor>,
        onImageRequest: @escaping () -> Void,
        onCancelRequest: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onImageRequest = onImageRequest
        self.onCancelRequest = onCancelRequest
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.onReuse = { [weak self] in self?.releaseCell() }
        cell?.onReload = onImageRequest
        cell?.configure(with: viewModel)
        onImageRequest()
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onCancelRequest()
    }
    
    private func releaseCell() {
        cell = nil
    }
}

extension ListPokemonItemViewController: ResourceLoadingView {
    public func display(loadingViewModel: LoadingViewModel) {
        cell?.display(isLoading: loadingViewModel.isLoading)
    }
}

extension ListPokemonItemViewController: ResourceErrorView {
    public func display(errorViewModel: ErrorViewModel) {
        cell?.display(reload: errorViewModel.needToShowError)
    }
}

extension ListPokemonItemViewController: ResourceView {
    public func display(viewModel image: UIImage) {
        cell?.display(image: image)
    }
}
