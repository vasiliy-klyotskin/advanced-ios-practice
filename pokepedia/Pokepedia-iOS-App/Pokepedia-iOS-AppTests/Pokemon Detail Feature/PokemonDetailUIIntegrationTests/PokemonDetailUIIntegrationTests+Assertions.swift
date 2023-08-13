//
//  PokemonDetailUIIntegrationTests+Assertions.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 7/26/23.
//

import XCTest
import Pokepedia
@testable import Pokepedia_iOS

extension PokemonDetailUIIntegrationTests {
    func assertThat(
        _ sut: ListViewController,
        isRendering detail: DetailPokemon?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectedAbilitiesTitle = detail == nil ? nil : DetailPokemonPresenter.abilitiesTitle
        
        assertThat(sut, hasViewConfiguredFor: detail?.info, file: file, line: line)
        assertThatSutHasConfiguredForAbilitiesTitle(sut, expectedTitle: expectedAbilitiesTitle, file: file, line: line)
        assertThatSutHasConfiguredForAbilitiesItems(sut, detail: detail, file: file, line: line)
    }
    
    func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredFor info: DetailPokemonInfo?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let view = sut.pokemonDetailInfoView()
        let cell = view as? DetailPokemonInfoCell
        XCTAssertEqual(
            cell?.idText,
            info.map { String(format: "%04d", $0.id) },
            "Expected id to be \(String(describing: info?.id)) for info view",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell?.nameText,
            info?.name,
            "Expected name to be \(String(describing: info?.name)) for info view",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell?.flavorText,
            info?.flavorText,
            "Expected flavor text to be \(String(describing: info?.flavorText)) for info view",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell?.genusText,
            info?.genus,
            "Expected genus to be \(String(describing: info?.genus)) for info view",
            file: file,
            line: line
        )
    }
    
    private func assertThatSutHasConfiguredForAbilitiesTitle(
        _ sut: ListViewController,
        expectedTitle: String?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let view = sut.pokemonDetailAbilitiesTitleView()
        let cell = view as? TitleCell
        
        XCTAssertEqual(
            cell?.text,
            expectedTitle,
            "Expected title to be \(expectedTitle ?? "nil")",
            file: file,
            line: line
        )
    }
    
    private func assertThatSutHasConfiguredForAbilitiesItems(
        _ sut: ListViewController,
        detail: DetailPokemon?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedAbilities() == (detail?.abilities.count ?? 0) else {
            return XCTFail("Expected \(detail?.abilities.count ?? 0) abilities, got \(sut.numberOfRenderedAbilities()) instead.", file: file, line: line)
        }
        detail?.abilities.enumerated().forEach { index, ability in
            assertThat(sut, hasViewConfiguredFor: ability, at: index, file: file, line: line)
        }
    }
    
    func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredFor ability: DetailPokemonAbility?,
        at index: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let view = sut.pokemonDetailAbilityView(for: index)
        let cell = view as? DetailPokemonAbilityCell
        XCTAssertEqual(
            cell?.titleText,
            ability?.title,
            "Expected title to be \(String(describing: ability?.title)) for ability view at index (\(index))",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell?.subtitleText,
            ability?.subtitle,
            "Expected subtitle to be \(String(describing: ability?.subtitle)) for ability view at index (\(index))",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell?.damageClassText,
            ability?.damageClass,
            "Expected damage class to be \(String(describing: ability?.damageClass)) for ability view at index (\(index))",
            file: file,
            line: line
        )
        XCTAssertEqual(
            cell?.typeText,
            ability?.type,
            "Expected type to be \(String(describing: ability?.type)) for ability view at index (\(index)",
            file: file,
            line: line
        )
    }
}
