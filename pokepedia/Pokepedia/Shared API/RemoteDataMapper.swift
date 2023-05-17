//
//  RemoteDataMapper.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/16/23.
//

import Foundation

public enum RemoteDataMapper {
    struct APIError: Error {}
    
    public static func map(data: Data, response: HTTPURLResponse) throws {
        //if data.isEmpty { throw APIError() }
        throw NSError()
    }
}
