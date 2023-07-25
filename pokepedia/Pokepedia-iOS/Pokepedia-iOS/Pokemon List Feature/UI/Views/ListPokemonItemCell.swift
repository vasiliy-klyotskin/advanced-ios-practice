//
//  ListPokemonItemCell.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 6/2/23.
//

import UIKit
import Pokepedia

public final class ListPokemonItemCell: UITableViewCell {
    var onReload: (() -> Void)?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var specialTypeLabel: UILabel!
    @IBOutlet weak var specialTypeContainer: UIView!
    @IBOutlet weak var physicalTypeContainer: UIView!
    @IBOutlet weak var physicalTypeLabel: UILabel!
    @IBOutlet weak var pokemonIconView: UIImageView!
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var content: UIView!
    
    convenience init() {
        self.init(frame: .zero)
        loadFromNib()
        configureUI()
    }
    
    private func configureUI() {
        content.fit(in: contentView)
        reloadButton.addTarget(self, action: #selector(onReloadTapped), for: .touchUpInside)
        nameLabel.font = .standard(size: .title, weight: .semibold)
        idLabel.font = .standard(size: .body, weight: .regular)
        physicalTypeLabel.font = .standard(size: .caption, weight: .regular)
        specialTypeLabel.font = .standard(size: .caption, weight: .regular)
    }
    
    func configure(with viewModel: ListPokemonItemViewModel<UIColor>) {
        idLabel.text = viewModel.id
        nameLabel.text = viewModel.name
        physicalTypeLabel.text = viewModel.physicalType
        specialTypeLabel.text = viewModel.specialType
        specialTypeContainer.isHidden = !viewModel.shouldShowSpecialType
        physicalTypeContainer.backgroundColor = viewModel.physicalTypeColor
        specialTypeContainer.backgroundColor = viewModel.specialTypeColor
    }
    
    func display(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicatorContainer.isHidden = !isLoading
    }
    
    func display(reload: Bool) {
        reloadButton.isHidden = !reload
    }
    
    func display(image: UIImage) {
        pokemonIconView.image = image
        pokemonIconView.isHidden = false
    }
    
    @objc private func onReloadTapped(_ sender: UIButton) {
        onReload?()
    }
}
