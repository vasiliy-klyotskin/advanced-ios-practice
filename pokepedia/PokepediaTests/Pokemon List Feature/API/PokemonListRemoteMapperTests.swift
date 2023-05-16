//
//  PokemonListRemoteMapperTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/16/23.
//

import XCTest
import Pokepedia

final class PokemonListRemoteMapperTests: XCTestCase {
    func test_map_returnsEmptyListOnEmptyRemote() throws {
        let emptryRemote: PokemonListRemote = []
        
        let list = try PokemonListRemoteMapper.map(remote: emptryRemote)
        
        XCTAssertTrue(list.isEmpty)
    }
}
