//
//  ListPokemonItemCell.swift
//  Pokepedia-iOS
//
//  Created by Vasiliy Klyotskin on 6/2/23.
//

import UIKit
import Pokepedia

public final class ListPokemonItemCell: UITableViewCell {
    var onReload: (() -> Void)?
    var onReuse: (() -> Void)?
    
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
    
    @IBAction private func onReloadTap(_ sender: UIButton) {
        onReuse?()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadFromNib()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        onReuse?()
        reset()
    }
    
    private func configureUI() {
        selectionStyle = .none
        content.fit(in: contentView)
        nameLabel.adjustsFontForContentSizeCategory = true
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
            pokemonIconView.isHidden = true
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
    
    private func reset() {
        activityIndicatorContainer.isHidden = true
        reloadButton.isHidden = true
        pokemonIconView.image = nil
        pokemonIconView.isHidden = true
    }
}
