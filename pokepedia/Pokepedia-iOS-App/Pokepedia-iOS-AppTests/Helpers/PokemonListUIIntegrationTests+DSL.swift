//
//  PokemonListUIIntegrationTests+DSL.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/31/23.
//

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
}

extension PokemonListUIIntegrationTests {
    var pokemonListTitle: String {
        PokemonListPresenter.title
    }
    
    var loadError: String {
        LoadingResourcePresenter<Any, DummyView>.loadError
    }
}

private struct DummyView: ResourceView {
    func display(resourceViewModel: Any) {}
}
