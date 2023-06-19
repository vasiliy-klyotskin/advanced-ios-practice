//
//  ListPokemonItemCell.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit

public final class ListPokemonItemCell: UITableViewCell {
    var onReload: (() -> Void)?
    
    let nameLabel = UILabel()
    let idLabel = UILabel()
    let specialTypeLabel = UILabel()
    let physicalTypeLabel = UILabel()
    let pokemonIconView = UIImageView()
    
    var loading: Bool = false
    var reload: Bool = false
    
    var reloadButton: UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(tappedReload), for: .touchUpInside)
        return button
    }
    
    @objc private func tappedReload() {
        onReload?()
    }
}
