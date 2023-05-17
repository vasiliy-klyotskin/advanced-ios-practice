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
        if data.isEmpty || !response.isOk { throw APIError() }
        return data
    }
}
