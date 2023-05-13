//
//  URLSessionHTTPClient.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 13.05.2023.
//

import Foundation

public final class URLSessionHTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    public typealias Cancellable = () -> Void
    
    @discardableResult
    public func perform(_ request: URLRequest, completion: @escaping (Result) -> Void) -> Cancellable {
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return task.cancel
    }
}
