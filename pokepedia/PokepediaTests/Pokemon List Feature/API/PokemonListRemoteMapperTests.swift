//
//  PokemonListRemoteMapperTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/16/23.
//

import XCTest
@testable import Pokepedia

final class PokemonListRemoteMapperTests: XCTestCase {
    func test_map_deliversEmptyListOnEmptyRemote() {
        let emptryRemote: PokemonListRemote = []
        
        let list = PokemonListRemoteMapper.map(remote: emptryRemote)
        
        XCTAssertTrue(list.isEmpty)
    }
    
    func test_map_deliversListOnNonEmptyRemote() {
        let (remote0, model0) = makeItem(specialType: nil)
        let (remote1, model1) = makeItem(specialType: ("any color", "any name"))
        let remote = [remote0, remote1]
        let expectedList = [model0, model1]
        
        let resultList = PokemonListRemoteMapper.map(remote: remote)
        
        XCTAssertEqual(resultList, expectedList)
    }
    
    // MARK: - Helpers
    
    private func makeItem(specialType: (color: String, name: String)?) -> (ListPokemonItemRemote, PokemonListItem) {
        let remote = ListPokemonItemRemote(
            id: 1,
            name: "any name",
            iconUrl: anyURL(),
            physicalType: .init(color: "any color", name: "any name"),
            specialType: specialType.map { .init(color: $0.color, name: $0.name) }
        )
        let model = PokemonListItem(
            id: remote.id,
            name: remote.name,
            imageUrl: remote.iconUrl,
            physicalType: .init(color: remote.physicalType.color, name: remote.physicalType.name),
            specialType: specialType.map { .init(color: $0.color, name: $0.name) }
        )
        return (remote, model)
    }
}
