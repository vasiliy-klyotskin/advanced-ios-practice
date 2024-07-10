//
//  DetailPokemonEndpointTests.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/20/23.
//

import XCTest
import Pokepedia

final class DetailPokemonEndpointTests: XCTestCase {
    func test_make_createsUrlRequest() {
        let baseURL = URL(string: "http://base-url.com:8080")!
        let ids = [0, 1, 2]
        
        ids.forEach { id in
            let received = DetailPokemonEndpoint.get(id).make(with: baseURL)
            
            XCTAssertEqual(received.url?.port, baseURL.port)
            XCTAssertEqual(received.url?.scheme, "http", "scheme for \(id)")
            XCTAssertEqual(received.url?.host, "base-url.com", "host for \(id)")
            XCTAssertEqual(received.url?.path, "/detail", "path for \(id)")
            XCTAssertEqual(received.url?.port, 8080, "port for \(id)")
            XCTAssertEqual(received.url?.query, "id=\(id)", "query for \(id)")
            XCTAssertEqual(received.httpMethod, "GET", "method for \(id)")
        }
    }
}
