//
//  PokemonListUIIntegrationTests+Assertions.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 6/1/23.
//

import XCTest
import Pokepedia
import Pokepedia_iOS

extension PokemonListUIIntegrationTests {
    func assertThat(
        _ sut: PokemonListViewController,
        isRendering list: PokemonList,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedListPokemons() == list.count else {
            return XCTFail("Expected \(list.count) items, got \(sut.numberOfRenderedListPokemons()) instead.", file: file, line: line)
        }
        
        list.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    func assertThat(
        _ sut: PokemonListViewController,
        hasViewConfiguredFor item: PokemonListItem,
        at index: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let view = sut.pokemonItemView(at: index)
        
        guard let cell = view as? ListPokemonItemCell else {
            return XCTFail("Expected \(ListPokemonItemCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(
            cell.specialTypeNameText,
            item.specialType?.name,
            "Expected special type name to be \(String(describing: item.specialType?.name)) for image view at index (\(index))",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell.mainTypeNameText,
            item.physicalType.name,
            "Expected main type name to be \(String(describing: item.physicalType.name)) for image view at index (\(index))",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell.nameText,
            item.name,
            "Expected name text to be \(String(describing: item.name)) for image view at index (\(index))",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell.idText,
            item.id,
            "Expected id text to be \(String(describing: item.id)) for image view at index (\(index)",
            file: file,
            line: line
        )
    }
}
