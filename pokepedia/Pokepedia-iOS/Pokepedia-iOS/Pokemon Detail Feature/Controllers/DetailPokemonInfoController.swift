//
//  DetailPokemonInfoController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia

public final class DetailPokemonInfoController: NSObject, UITableViewDataSource {
    private let viewModel: DetailPokemonInfoViewModel
    
    public init(viewModel: DetailPokemonInfoViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DetailPokemonInfoCell()
        cell.configure(with: viewModel)
        return cell
    }
}
