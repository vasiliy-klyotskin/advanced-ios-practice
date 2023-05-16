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
                try RemoteMapper.map(data: anyData(), response: response(code: sample))
            )
        }
    }
    
    func test_map_deliversErrorOnInvalid200Response() {
        let invalidData = Data("invalid data".utf8)

        XCTAssertThrowsError(
            try RemoteMapper.map(data: invalidData, response: response(code: 200))
        )
    }

    // MARK: Helpers
    
    private func response(code: Int) -> HTTPURLResponse {
        .init(
            url: anyURL(),
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
