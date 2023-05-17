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
    
    func test_map_throwsAnErrorOnItemWithEmptyTypesInRemote() {
        let (remoteWithNoTypes, _) = makeItem(remoteTypes: [])
        let (remoteWithOneType, _) = makeItem(remoteTypes: [
            ("any color", "any name")
        ])
        let (remoteWithTwoTypes, _) = makeItem(remoteTypes: [
            ("any color", "any name"),
            ("any color", "any name")
        ])
        let remote = [remoteWithNoTypes, remoteWithOneType, remoteWithTwoTypes]

        XCTAssertThrowsError(
            try PokemonListRemoteMapper.map(remote: remote)
        )
    }
    
    func test_map_deliversListOnValidRemote() throws {
        let (remote0, model0) = makeItem(
            remoteTypes: [("color 1", "name 1"), ("color 2", "name 2")],
            physicalType: ("color 1", "name 1"),
            specialType: ("color 2", "name 2")
        )
        let (remote1, model1) = makeItem(
            remoteTypes: [("color 1", "name 1")],
            physicalType: ("color 1", "name 1"),
            specialType: nil
        )
        let remote = [remote0, remote1]
        let expectedList = [model0, model1]
        
        
        let resultList = try PokemonListRemoteMapper.map(remote: remote)
        
        XCTAssertEqual(resultList, expectedList)
    }
    
    // MARK: - Helpers
    
    private func makeItem(
        id: String? = nil,
        name: String? = nil,
        imageUrl: URL? = nil,
        remoteTypes: [(color: String, name: String)],
        physicalType: (color: String, name: String)? = nil,
        specialType: (color: String, name: String)? = nil
    ) -> (ListPokemonItemRemote, PokemonListItem) {
        let remote = ListPokemonItemRemote(
            id: id ?? anyId(),
            name: name ?? anyName(),
            imageUrl: imageUrl ?? anyURL(),
            types: remoteTypes.map { .init(color: $0.color, name: $0.name) }
        )
        let model = PokemonListItem(
            id: remote.id,
            name: remote.name,
            iconUrl: remote.imageUrl,
            physicalType: .init(
                color: physicalType?.color ?? anyId(),
                name: physicalType?.name ?? anyId()
            ),
            specialType: specialType.map { .init(
                color: $0.color,
                name: $0.name)
            }
        )
        return (remote, model)
    }
}
