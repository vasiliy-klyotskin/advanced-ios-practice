//
//  RemoteMapper.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/16/23.
//

import Foundation

public enum RemoteMapper<Item: Decodable> {
    struct APIError: Error {}
    
    public static func map(data: Data, response: HTTPURLResponse) throws -> Item {
        guard isOk(response) else { throw APIError() }
        return try JSONDecoder().decode(Item.self, from: data)
    }
    
    private static func isOk(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }
}
