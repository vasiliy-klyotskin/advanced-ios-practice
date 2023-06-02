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
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    var errorMessage: String? {
        return errorView.errorMessageLabel.text
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
}
