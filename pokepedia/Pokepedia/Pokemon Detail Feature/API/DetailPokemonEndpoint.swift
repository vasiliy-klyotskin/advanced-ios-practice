//
//  DetailPokemonEndpoint.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 8/20/23.
//

import Foundation

public enum DetailPokemonEndpoint {
    public typealias ID = Int
    
    case get(ID)
    
    public func make(with baseUrl: URL) -> URLRequest {
        switch self {
        case .get(let id):
            var components = URLComponents()
            components.port = baseUrl.port
            components.scheme = baseUrl.scheme
            components.host = baseUrl.host
            components.path = baseUrl.path + "/detail"
            components.queryItems = [
                .init(name: "id", value: "\(id)"),
            ]
            return URLRequest(url: components.url!)
        }
    }
}
