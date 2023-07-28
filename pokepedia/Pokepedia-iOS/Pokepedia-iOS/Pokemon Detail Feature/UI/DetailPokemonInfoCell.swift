//
//  DetailPokemonInfoCell.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia

public final class DetailPokemonInfoCell: UITableViewCell {
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genusLabel: UILabel!
    @IBOutlet var flavorLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var reloadButton: UIButton!
    @IBOutlet var pokemonImageView: UIImageView!
    @IBOutlet private var content: UIView!
    @IBOutlet private var imageContainer: UIView!
    
    var onReload: () -> Void = {}
    
    convenience init() {
        self.init(frame: .zero)
        loadFromNib()
        configureUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        makeImageContainerCircular()
    }
    
    func configure(with viewModel: DetailPokemonInfoViewModel) {
        idLabel.text = viewModel.id
        nameLabel.text = viewModel.name
        genusLabel.text = viewModel.genus
        flavorLabel.text = viewModel.flavorText
    }
    
    func display(isLoading: Bool) {
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
        pokemonImageView.image = image
        pokemonImageView.isHidden = false
    }
    
    private func configureUI() {
        content.fit(in: contentView)
        configureActivityIndicator()
        setupFonts()
        removeSeparator()
        setupReloadButton()
    }
    
    private func setupReloadButton() {
        reloadButton.addTarget(self, action: #selector(onReloadTapped), for: .touchUpInside)
    }
    
    private func removeSeparator() {
        separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
    }
    
    private func setupFonts() {
        nameLabel.font = .standard(size: .headline, weight: .semibold)
        idLabel.font = .standard(size: .headline, weight: .regular)
        genusLabel.font = .standard(size: .title, weight: .regular)
        flavorLabel.font = .standard(size: .title, weight: .regular)
    }
    
    private func configureActivityIndicator() {
        let scale = CGAffineTransform(scaleX: 1.7, y: 1.7)
        activityIndicator.transform = scale
        activityIndicator.alpha = 0.7
    }
    
    private func makeImageContainerCircular() {
        let radius: CGFloat = imageContainer.bounds.size.width / 2.0
        imageContainer.layer.cornerRadius = radius
        imageContainer.layer.cornerRadius = radius
        imageContainer.clipsToBounds = true
    }
    
    @objc private func onReloadTapped(_ sender: UIButton) {
        onReload()
    }
}
