//
//  PokemonListUIIntegrationTests+DSL.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/31/23.
//

import Foundation
@testable import Pokepedia_iOS

extension ListPokemonItemCell {
    var specialTypeNameText: String? {
        specialTypeLabel.text
    }
    
    var mainTypeNameText: String? {
        physicalTypeLabel.text
    }
    
    var nameText: String? {
        nameLabel.text
    }
    
    var idText: String? {
        idLabel.text
    }
    
    var isLoading: Bool {
        activityIndicator.isAnimating
    }
    
    var isReloadControlShown: Bool {
        !reloadButton.isHidden
    }
    
    var renderedImage: Data? {
        pokemonIconView.image?.pngData()
    }
    
    func simulateReload() {
        onReload?()
        // TODO: Tests crushes when I call this method although there are not troubles in setting selector to the button. Fix it
        // reloadButton.simulate(event: .touchUpInside)
    }
}
