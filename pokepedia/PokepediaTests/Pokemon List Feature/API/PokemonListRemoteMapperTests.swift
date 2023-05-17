//
//  PokemonListRemoteMapperTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/16/23.
//

import XCTest
@testable import Pokepedia

final class PokemonListRemoteMapperTests: XCTestCase {
    func test_map_returnsEmptyListOnEmptyRemote() throws {
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
