//
//  RemoteDataMapper.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/16/23.
//

import Foundation

public enum RemoteDataMapper {
    struct APIError: Error {}
    
    public static func map(data: Data, response: HTTPURLResponse) throws -> Data {
        if data.isEmpty || !isOk(response) { throw APIError() }
        return data
    }
    
    private static func isOk(_ response: HTTPURLResponse) -> Bool {
        return response.statusCode == 200
    }
}
