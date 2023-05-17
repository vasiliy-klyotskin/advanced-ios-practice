//
//  RemoteDataMapperTests.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/16/23.
//

import XCTest
import Pokepedia

final class RemoteDataMapperTests: XCTestCase {
    func test_map_deliversErrorOnNon200Response()  {
        let non200Codes = [100, 199, 201, 299, 300, 400, 500]
        
        for sample in non200Codes {
            XCTAssertThrowsError(
                try RemoteDataMapper.map(data: anyData(), response: response(code: sample))
            )
        }
    }
    
    func test_map_deliversErrorOnEmpty200Response() {
        let emptyData = Data()

        XCTAssertThrowsError(
            try RemoteDataMapper.map(data: emptyData, response: response(code: 200))
        )
    }
//
//    func test_map_deliversRemoteItemOnValid200Response() throws {
//        let (validData, expectedItem) = makeRemoteItem(
//            string: "any string value",
//            int: 10,
//            optionalString: nil
//        )
//
//        let resultItem: RemoteItem = try RemoteMapper.map(data: validData, response: response(code: 200))
//
//        XCTAssertEqual(expectedItem, resultItem)
//    }
}
