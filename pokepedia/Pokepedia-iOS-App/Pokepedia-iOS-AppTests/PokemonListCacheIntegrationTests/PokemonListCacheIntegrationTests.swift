//
//  PokemonListCacheIntegrationTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/8/23.
//

import XCTest
import Pokepedia

final class PokemonListCacheFacade {
    func loadList() throws -> PokemonList {
        throw NSError(domain: "", code: 1)
    }
}

enum PokemonListCacheComposer {
    static func compose() -> PokemonListCacheFacade {
        PokemonListCacheFacade()
    }
}

final class PokemonListCacheIntegrationTests: XCTestCase {
    
    func test_deliverNoListOnEmptyCache() throws {
        let sut = makeSut()
        
        let list = try? sut.loadList()
        
        XCTAssertNil(list)
    }
    
    // MARK: - Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> PokemonListCacheFacade {
        PokemonListCacheComposer.compose()
    }
}
