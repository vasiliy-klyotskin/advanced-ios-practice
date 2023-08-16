//
//  PokemonListEndpointTest.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/15/23.
//

import XCTest
import Pokepedia

final class PokemonListEndpointTest: XCTestCase {
    func test_make_createsUrlRequestForAllList() {
        let baseURL = URL(string: "http://base-url.com:8080")!
        
        let received = PokemonListEndpoint.get().make(with: baseURL)
        
        XCTAssertEqual(received.url?.port, baseURL.port)
        XCTAssertEqual(received.url?.scheme, "http", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/list", "path")
        XCTAssertEqual(received.url?.query, "after_id=-1&limit=20", "query")
        XCTAssertEqual(received.httpMethod, "GET")
    }
    
    func test_make_createsUrlRequestAfterSpecificItem() {
        let item = anyItem(withId: 17)
        let baseURL = URL(string: "http://base-url.com:8080")!
        
        let received = PokemonListEndpoint.get(after: item).make(with: baseURL)
        
        XCTAssertEqual(received.url?.port, baseURL.port)
        XCTAssertEqual(received.url?.scheme, "http", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/list", "path")
        XCTAssertEqual(received.url?.query, "after_id=17&limit=20", "query")
        XCTAssertEqual(received.httpMethod, "GET")
    }
    
    // MARK: - Helpers
    
    private func anyItem(withId id: Int) -> PokemonListItem {
        PokemonListItem(id: id, name: "any name", imageUrl: anyURL(), physicalType: .init(color: "any color", name: "any name"), specialType: nil)
    }
}
