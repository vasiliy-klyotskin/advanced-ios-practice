//
//  DetailPokemonAbilityController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia

public final class DetailPokemonAbilityController: NSObject, UITableViewDataSource {
    private let viewModel: DetailPokemonAbilityViewModel<UIColor>
    
    public init(viewModel: DetailPokemonAbilityViewModel<UIColor>) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DetailPokemonAbilityCell()
        cell.configure(with: viewModel)
        return cell
    }
}
