//
//  PokemonListRemoteMapperTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/16/23.
//

import XCTest
@testable import Pokepedia

final class PokemonListRemoteMapperTests: XCTestCase {
    func test_map_deliversEmptyListOnEmptyRemote() throws {
        let emptryRemote: PokemonListRemote = []
        
        let list = try PokemonListRemoteMapper.map(remote: emptryRemote)
        
        XCTAssertTrue(list.isEmpty)
    }
    
    func test_map_deliversListOnNonEmptyRemote() throws {
        let (remote0, model0) = makeItem(specialType: nil)
        let (remote1, model1) = makeItem(specialType: ("any color", "any name"))
        let remote = [remote0, remote1]
        let expectedList = [model0, model1]
        
        let resultList = try PokemonListRemoteMapper.map(remote: remote)
        
        XCTAssertEqual(resultList, expectedList)
    }
    
    // MARK: - Helpers
    
    private func makeItem(specialType: (color: String, name: String)?) -> (ListPokemonItemRemote, PokemonListItem) {
        let remote = ListPokemonItemRemote(
            id: anyId(),
            name: anyName(),
            iconUrl: anyURL(),
            physicalType: .init(color: anyKey(), name: anyKey()),
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
