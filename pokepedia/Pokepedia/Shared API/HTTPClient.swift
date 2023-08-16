//
//  HTTPClient.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 8/16/23.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func perform(_ request: URLRequest, completion: @escaping (Result) -> Void) -> HTTPClientTask
}
