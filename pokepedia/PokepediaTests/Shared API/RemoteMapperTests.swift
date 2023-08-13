//
//  RemoteMapperTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/16/23.
//

import XCTest
import Pokepedia

final class RemoteMapperTests: XCTestCase {
    func test_map_deliversErrorOnNon200Response()  {
        let non200Codes = [100, 199, 201, 299, 300, 400, 500]
        
        for sample in non200Codes {
            XCTAssertThrowsError(
                try RemoteMapper<RemoteItem>.map(data: Data("any data".utf8), response: response(code: sample))
            )
        }
    }
    
    func test_map_deliversErrorOnInvalid200Response() {
        let invalidData = Data("invalid data".utf8)

        XCTAssertThrowsError(
            try RemoteMapper<RemoteItem>.map(data: invalidData, response: response(code: 200))
        )
    }
    
    func test_map_deliversRemoteItemOnValid200Response() throws {
        let (validData, expectedItem) = makeRemoteItem(
            string: "any string value",
            int: 10,
            optionalString: nil
        )
        
        let resultItem: RemoteItem = try RemoteMapper.map(data: validData, response: response(code: 200))
        
        XCTAssertEqual(expectedItem, resultItem)
    }

    // MARK: - Helpers
    
    private func response(code: Int) -> HTTPURLResponse {
        .init(
            url: anyURL(),
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    private func makeRemoteItem(
        string: String,
        int: Int,
        optionalString: String?
    ) -> (jsonData: Data, remote: RemoteItem) {
        let remote = RemoteItem(string: string, int: int, optionalString: optionalString)
        let json = [
            "string": string,
            "int": int,
            "optionalString": optionalString as Any,
        ].compactMapValues { $0 }
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        return (jsonData, remote)
    }
    
    private struct RemoteItem: Decodable, Equatable {
        let string: String
        let int: Int
        let optionalString: String?
    }
}
