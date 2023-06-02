//
//  ListPokemonItemViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit
import Pokepedia

public final class ListPokemonItemViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    let viewModel: ListPokemonItemViewModel
    let onImageRequest: () -> Void
    
    public init(viewModel: ListPokemonItemViewModel, onImageRequest: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onImageRequest = onImageRequest
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListPokemonItemCell()
        cell.idLabel.text = viewModel.id
        cell.nameLabel.text = viewModel.name
        cell.physicalTypeLabel.text = viewModel.physicalType
        cell.specialTypeLabel.text = viewModel.specialType
        onImageRequest()
        return cell
    }
}
