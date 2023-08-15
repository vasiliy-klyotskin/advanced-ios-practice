//
//  PokemonListEndpointTest.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 8/15/23.
//

import XCTest
import Pokepedia

enum PokemonListEndpoint {
    case get(after: PokemonListItem? = nil)
    
    func make(with baseUrl: URL) -> URLRequest {
        switch self {
        case .get(let item):
            var components = URLComponents()
            components.scheme = baseUrl.scheme
            components.host = baseUrl.host
            components.path = baseUrl.path + "/list"
            components.queryItems = [
                .init(name: "after_id", value: "\(item?.id ?? 0)"),
                .init(name: "limit", value: "20")
            ]
            return URLRequest(url: components.url!)
        }
    }
}

final class PokemonListEndpointTest: XCTestCase {
    func test_make_createsUrlRequestForAllList() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = PokemonListEndpoint.get().make(with: baseURL)
        
        XCTAssertEqual(received.url?.scheme, "http", "scheme")
        XCTAssertEqual(received.url?.host, "base-url.com", "host")
        XCTAssertEqual(received.url?.path, "/list", "path")
        XCTAssertEqual(received.url?.query, "after_id=0&limit=20", "query")
        XCTAssertEqual(received.httpMethod, "GET")
    }
    
    func test_make_createsUrlRequestAfterSpecificItem() {
        let item = anyItem(withId: 17)
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = PokemonListEndpoint.get(after: item).make(with: baseURL)
        
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
