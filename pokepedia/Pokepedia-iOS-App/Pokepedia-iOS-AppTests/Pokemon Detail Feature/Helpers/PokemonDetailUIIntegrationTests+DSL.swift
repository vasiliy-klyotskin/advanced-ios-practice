//
//  PokemonDetailUIIntegrationTests+DSL.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/26/23.
//

import UIKit
@testable import Pokepedia_iOS

extension DetailPokemonInfoCell {
    var nameText: String? {
        nameLabel.text
    }
    
    var idText: String? {
        idLabel.text
    }
    
    var genusText: String? {
        genusLabel.text
    }
    
    var flavorText: String? {
        flavorLabel.text
    }
    
    var isLoading: Bool {
        activityIndicator.isAnimating
    }
    
    var isReloadControlShown: Bool {
        !reloadButton.isHidden
    }
    
    var detailRenderedImage: Data? {
        pokemonImageView.image?.pngData()
    }
    
    func simulateReload() {
        onReload()
        // TODO: Tests crushes when I call this method although there are not troubles in setting selector to the button. Fix it
        // reloadButton.simulate(event: .touchUpInside)
    }
}

extension DetailPokemonAbilityCell {
    var titleText: String? {
        titleLabel.text
    }
    
    var subtitleText: String? {
        subtitleLabel.text
    }
    
    var damageClassText: String? {
        damageClassLabel.text
    }
    
    var typeText: String? {
        typeLabel.text
    }
}

extension TitleCell {
    var text: String? {
        label.text
    }
}

extension ListViewController {
    func pokemonDetailInfoView() -> UIView? {
        tableView.dataSource?.tableView(tableView, cellForRowAt: .init(row: infoViewRow, section: detailSectionNumber))
    }
    
    func pokemonDetailAbilitiesTitleView() -> UIView? {
        tableView.dataSource?.tableView(tableView, cellForRowAt: .init(row: abilitiesTitleRow, section: detailSectionNumber))
    }
    
    func pokemonDetailAbilityView(for index: Int) -> UIView? {
        tableView.dataSource?.tableView(tableView, cellForRowAt: .init(row: abilityRow(for: index), section: detailSectionNumber))
    }
    
    func numberOfRenderedAbilities() -> Int {
        if let numberOfRows = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: detailSectionNumber), numberOfRows != 0 {
            return numberOfRows - 2
        } else {
            return 0
        }
    }
    
    @discardableResult
    func simulatePokemonDetailInfoViewVisible() -> DetailPokemonInfoCell? {
        pokemonDetailInfoView() as? DetailPokemonInfoCell
    }
    
    var infoViewRow: Int { 0 }
    var abilitiesTitleRow: Int { 1 }
    func abilityRow(for index: Int) -> Int { index + 2 }
    var detailSectionNumber: Int { 0 }
}
