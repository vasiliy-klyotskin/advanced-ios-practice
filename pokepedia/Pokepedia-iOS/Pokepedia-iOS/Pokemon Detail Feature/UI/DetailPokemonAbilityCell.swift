//
//  Views.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia

public final class DetailPokemonAbilityCell: UITableViewCell {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let damageClassLabel = UILabel()
    let typeLabel = UILabel()
    
    func configure(with viewModel: DetailPokemonAbilityViewModel<UIColor>) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        damageClassLabel.text = viewModel.damageClass
        typeLabel.text = viewModel.type
    }
}
