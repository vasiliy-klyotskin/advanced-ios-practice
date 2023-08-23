//
//  PokepediaAPIEndToEndTests.swift
//  PokepediaAPIEndToEndTests
//
//  Created by Василий Клецкин on 8/15/23.
//

import XCTest
import Pokepedia

final class PokepediaAPIEndToEndTests: XCTestCase {
    func test_e2eApi_returnsExpectedPokemonList() {
        switch getListResult() {
        case .success(let receivedList):
            XCTAssertEqual(receivedList.count, 5, "Expected 5 items")
            XCTAssertEqual(receivedList[0], expectedItem(for: 0))
            XCTAssertEqual(receivedList[1], expectedItem(for: 1))
            XCTAssertEqual(receivedList[2], expectedItem(for: 2))
            XCTAssertEqual(receivedList[3], expectedItem(for: 3))
            XCTAssertEqual(receivedList[4], expectedItem(for: 4))
        case .failure(let error):
            XCTFail("Expected success but got error: \(error.localizedDescription)")
        default:
            XCTFail("Expected success but got no result")
        }
    }
    
    func test_e2eApi_returnsListItemIcon() {
        switch getImageResult(for: listIconUrl()) {
        case .success(let data):
            XCTAssertFalse(data.isEmpty, "Data should not be empty")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error.localizedDescription)")
        default:
            XCTFail("Expected success but got no result")
        }
    }
    
    func test_e2eApi_returnsExpectedDetail() {
        switch getDetailResult() {
        case .success(let receivedDetail):
            XCTAssertEqual(receivedDetail, expectedDetail())
        case .failure(let error):
            XCTFail("Expected success but got error: \(error.localizedDescription)")
        default:
            XCTFail("Expected success but got no result")
        }
    }
    
    func test_e2eApi_returnsDetailImage() {
        switch getImageResult(for: detailImageUrl()) {
        case .success(let data):
            XCTAssertFalse(data.isEmpty, "Data should not be empty")
        case .failure(let error):
            XCTFail("Expected success but got error: \(error.localizedDescription)")
        default:
            XCTFail("Expected success but got no result")
        }
    }
    
    // MARK: - Helpers
    
    private func getListResult(file: StaticString = #filePath, line: UInt = #line) -> Result<PokemonList, Error>? {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let request = PokemonListEndpoint.get(after: nil, limit: 5).make(with: baseUrl)
        let dtoMapping = RemoteMapper<PokemonListRemote>.map
        let modelMapping = PokemonListRemoteMapper.map
        
        var result: Result<PokemonList, Error>?
        let exp = expectation(description: "Waiting for request to be completed")
        client.perform(request) { receivedResult in
            result = receivedResult.flatMap { (data, response) in
                Result { try dtoMapping(data, response) }
            }.map(modelMapping)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        return result
    }
    
    private func getImageResult(for url: URL, file: StaticString = #filePath, line: UInt = #line) -> Result<Data, Error>? {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let request = URLRequest(url: url)
        let dataMapping = RemoteDataMapper.map
        
        var result: Result<Data, Error>?
        let exp = expectation(description: "Waiting for request to be completed")
        client.perform(request) { receivedResult in
            result = receivedResult.flatMap { (data, response) in
                Result { try dataMapping(data, response) }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        return result
    }
    
    private func getDetailResult(file: StaticString = #filePath, line: UInt = #line) -> Result<DetailPokemon, Error>? {
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let request = DetailPokemonEndpoint.get(0).make(with: baseUrl)
        let dtoMapping = RemoteMapper<DetailPokemonRemote>.map
        let modelMapping = DetailPokemonRemoteMapper.map
        
        var result: Result<DetailPokemon, Error>?
        let exp = expectation(description: "Waiting for request to be completed")
        client.perform(request) { receivedResult in
            result = receivedResult.flatMap { (data, response) in
                Result { try dtoMapping(data, response) }
            }.map(modelMapping)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
        return result
    }
    
    
    private var baseUrl: URL {
        URL(string: "http://localhost:8080/test")!
    }
    
    private func listIconUrl() -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
    }
    
    private func detailImageUrl() -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")!
    }
    
    private func expectedItem(for index: Int) -> PokemonListItem {
        .init(
            id: id(for: index),
            name: name(for: index),
            imageUrl: imageUrl(for: index),
            physicalType: physicalType(for: index),
            specialType: specialType(for: index)
        )
    }
    
    private func id(for index: Int) -> Int {
        [
            0,
            1,
            2,
            3,
            4
        ][index]
    }
    
    private func name(for index: Int) -> String {
        [
            "Name A",
            "Name B",
            "Name C",
            "Name D",
            "Name E",
        ][index]
    }
    
    private func imageUrl(for index: Int) -> URL {
        [
            URL(string: "https://item-url-0.com")!,
            URL(string: "https://item-url-1.com")!,
            URL(string: "https://item-url-2.com")!,
            URL(string: "https://item-url-3.com")!,
            URL(string: "https://item-url-4.com")!
        ][index]
    }
    
    private func physicalType(for index: Int) -> PokemonListItemType {
        [
            .init(color: "000000", name: "Color name 0"),
            .init(color: "000010", name: "Color name 1"),
            .init(color: "000100", name: "Color name 2"),
            .init(color: "001000", name: "Color name 3"),
            .init(color: "010000", name: "Color name 4"),
        ][index]
    }
    
    private func specialType(for index: Int) -> PokemonListItemType? {
        [
            .init(color: "900000", name: "Color name 10"),
            nil,
            nil,
            .init(color: "901000", name: "Color name 13"),
            .init(color: "910000", name: "Color name 14"),
        ][index]
    }
    
    private func expectedDetail() -> DetailPokemon {
        .init(
            info: .init(
                imageUrl: URL(string: "http://detail-image-0.com")!,
                id: 0,
                name: "name",
                genus: "genus",
                flavorText: "flavor"
            ),
            abilities: [
                .init(
                    title: "title",
                    subtitle: "subtitle",
                    damageClass: "damage",
                    damageClassColor: "damageColor",
                    type: "type",
                    typeColor: "typeColor"
                )
            ]
        )
    }
}
