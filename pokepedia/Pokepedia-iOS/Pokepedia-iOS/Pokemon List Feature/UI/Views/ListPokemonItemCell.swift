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
        nameLabel.font = .preferredFont(forTextStyle: .body)
        idLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    func configure(with viewModel: ListPokemonItemViewModel) {
        idLabel.text = viewModel.id
        nameLabel.text = viewModel.name
        physicalTypeLabel.text = viewModel.physicalType
        specialTypeLabel.text = viewModel.specialType
        specialTypeContainer.isHidden = !viewModel.shouldShowSpecialType
    }
    
    func display(isLoading: Bool) {
        activityIndicatorContainer.isHidden = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func display(reload: Bool) {
        reloadButton.isHidden = !reload
    }
    
    func display(image: UIImage) {
        pokemonIconView.image = image
    }
    
    @objc private func onReloadTapped(_ sender: UIButton) {
        onReload?()
    }
}
