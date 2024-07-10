//
//  HTTPClientStub.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Vasiliy Klyotskin on 8/16/23.
//

import Foundation
import Pokepedia

final class HTTPClientStub: HTTPClient {
    struct Task: HTTPClientTask {
        func cancel() {}
    }
    
    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(request.url!))
        return Task()
    }
}

extension HTTPClientStub {
    static var offline: HTTPClientStub {
        .init(stub: { _ in .failure(NSError(domain: "no connectivity", code: -1)) })
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        .init(stub: { .success(stub($0)) })
    }
}
