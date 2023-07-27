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
        listPokemonItemView(at: index) as? ListPokemonItemCell
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    var errorMessage: String? {
        return errorView.message
    }
}
