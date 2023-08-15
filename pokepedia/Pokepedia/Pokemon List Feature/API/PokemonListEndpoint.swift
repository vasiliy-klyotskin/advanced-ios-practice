//
//  PokemonListEndpoint.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/15/23.
//

import Foundation

public enum PokemonListEndpoint {
    case get(after: PokemonListItem? = nil)
    
    public func make(with baseUrl: URL) -> URLRequest {
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
