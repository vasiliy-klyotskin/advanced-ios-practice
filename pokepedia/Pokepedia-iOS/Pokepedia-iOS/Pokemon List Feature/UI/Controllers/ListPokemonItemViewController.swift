//
//  ListPokemonItemViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit
import Pokepedia

public final class ListPokemonItemViewController: NSObject, UITableViewDataSource {
    let viewModel: ListPokemonItemViewModel
    
    public init(viewModel: ListPokemonItemViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListPokemonItemCell()
        cell.idLabel.text = viewModel.id
        cell.nameLabel.text = viewModel.name
        cell.physicalTypeLabel.text = viewModel.physicalType
        cell.specialTypeLabel.text = viewModel.specialType
        return cell
    }
}
