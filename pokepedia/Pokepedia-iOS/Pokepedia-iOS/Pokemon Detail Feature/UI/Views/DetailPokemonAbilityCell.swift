//
//  Views.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit
import Pokepedia

public final class DetailPokemonAbilityCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var damageClassLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet private var content: UIView!
    @IBOutlet private var damageClassContainer: UIView!
    @IBOutlet private var typeContainer: UIView!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadFromNib()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: DetailPokemonAbilityViewModel<UIColor>) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        damageClassLabel.text = viewModel.damageClass
        typeLabel.text = viewModel.type
        damageClassContainer.backgroundColor = viewModel.damageClassColor
        typeContainer.backgroundColor = viewModel.typeColor
    }
    
    private func configureUI() {
        content.fit(in: contentView)
        setupFonts()
    }
    
    private func setupFonts() {
        titleLabel.font = .standard(size: .title, weight: .semibold)
        subtitleLabel.font = .standard(size: .body, weight: .regular)
        damageClassLabel.font = .standard(size: .caption, weight: .regular)
        typeLabel.font = .standard(size: .caption, weight: .regular)
    }
}
