//
//  ListViewController+DSL.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/26/23.
//

import UIKit
@testable import Pokepedia_iOS

extension ListViewController {
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
