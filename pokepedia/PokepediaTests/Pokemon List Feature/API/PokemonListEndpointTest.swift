//
//  PokemonListEndpointTest.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/15/23.
//

import XCTest
import Pokepedia

enum PokemonListEndpoint {
    case get
    
    func make(with baseUrl: URL) -> URLRequest {
        var components = URLComponents()
        components.scheme = baseUrl.scheme
        components.host = baseUrl.host
        components.path = baseUrl.path + "/list"
        components.queryItems = [
            .init(name: "after_id", value: "0"),
            .init(name: "limit", value: "20")
        ]
        return URLRequest(url: components.url!)
    }
}

final class PokemonListEndpointTest: XCTestCase {
    func test_make_createsUrlRequestForAllList() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = PokemonListEndpoint.get.make(with: baseURL)
        
        XCTAssertEqual(received.url?.scheme, "http", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/list", "path")
        XCTAssertEqual(received.url?.query, "after_id=0&limit=20", "query")
        XCTAssertEqual(received.httpMethod, "GET")
    }
}
