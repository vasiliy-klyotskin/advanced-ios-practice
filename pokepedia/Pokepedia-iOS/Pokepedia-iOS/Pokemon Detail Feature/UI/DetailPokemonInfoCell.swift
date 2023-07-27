//
//  DetailPokemonInfoCell.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia

public final class DetailPokemonInfoCell: UITableViewCell {
    let idLabel = UILabel()
    let nameLabel = UILabel()
    let genusLabel = UILabel()
    let flavorLabel = UILabel()
    
    func configure(with viewModel: DetailPokemonInfoViewModel) {
        idLabel.text = viewModel.id
        nameLabel.text = viewModel.name
        genusLabel.text = viewModel.genus
        flavorLabel.text = viewModel.flavorText
    }
}
