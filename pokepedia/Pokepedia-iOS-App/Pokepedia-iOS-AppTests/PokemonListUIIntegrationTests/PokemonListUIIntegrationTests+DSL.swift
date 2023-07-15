//
//  PokemonListUIIntegrationTests+DSL.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/31/23.
//

import UIKit
import Pokepedia_iOS_App
import Pokepedia
@testable import Pokepedia_iOS

extension PokemonListViewController {
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> ListPokemonItemCell? {
        pokemonItemView(at: index) as? ListPokemonItemCell
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    func numberOfRenderedListPokemons() -> Int {
        tableView.dataSource?.tableView(tableView, numberOfRowsInSection: sectionNumber) ?? -1
    }
    
    func pokemonItemView(at index: Int) -> UIView? {
        tableView.dataSource?.tableView(tableView, cellForRowAt: .init(row: index, section: sectionNumber))
    }
    
    var sectionNumber: Int { 0 }
}

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
