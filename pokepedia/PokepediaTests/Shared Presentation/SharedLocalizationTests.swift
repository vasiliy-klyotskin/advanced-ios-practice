//
//  SharedLocalizationTests.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 5/22/23.
//

import XCTest
import Pokepedia

class SharedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadingResourcePresenter<Any, DummyView>.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
    private class DummyView: ResourceView {
        func display(viewModel: Any) {}
    }
}
