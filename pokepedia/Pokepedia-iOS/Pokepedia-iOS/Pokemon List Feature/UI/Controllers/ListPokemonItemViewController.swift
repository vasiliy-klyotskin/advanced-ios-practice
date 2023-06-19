//
//  ListPokemonItemViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit
import Pokepedia

public final class ListPokemonItemViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: ListPokemonItemViewModel
    private let onImageRequest: () -> Void
    
    let cell = ListPokemonItemCell()
    
    public init(viewModel: ListPokemonItemViewModel, onImageRequest: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onImageRequest = onImageRequest
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.onReload = onImageRequest
        cell.idLabel.text = viewModel.id
        cell.nameLabel.text = viewModel.name
        cell.physicalTypeLabel.text = viewModel.physicalType
        cell.specialTypeLabel.text = viewModel.specialType
        onImageRequest()
        return cell
    }
}

extension ListPokemonItemViewController: ResourceLoadingView {
    public func display(loadingViewModel: LoadingViewModel) {
        cell.loading = loadingViewModel.isLoading
    }
}

extension ListPokemonItemViewController: ResourceErrorView {
    public func display(errorViewModel: ErrorViewModel) {
        cell.reload = errorViewModel.needToShowError
    }
}

extension ListPokemonItemViewController: ResourceView {
    public func display(viewModel image: UIImage) {
        cell.pokemonIconView.image = image
    }
}
