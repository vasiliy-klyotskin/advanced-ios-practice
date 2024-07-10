//
//  PokemonListEndpoint.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/15/23.
//

import Foundation

public enum PokemonListEndpoint {
    case get(after: PokemonListItem? = nil, limit: Int = 20)
    
    public func make(with baseUrl: URL) -> URLRequest {
        switch self {
        case .get(let item, let limit):
            var components = URLComponents()
            components.port = baseUrl.port
            components.scheme = baseUrl.scheme
            components.host = baseUrl.host
            components.path = baseUrl.path + "/list"
            components.queryItems = [
                .init(name: "after_id", value: "\(item?.id ?? -1)"),
                .init(name: "limit", value: "\(limit)")
            ]
            return URLRequest(url: components.url!)
        }
    }
}
