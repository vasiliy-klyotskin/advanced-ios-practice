//
//  Helpers.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 13.05.2023.
//

import Foundation

func anyURL() -> URL {
    .init(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    .init(domain: "any domain", code: 1)
}

func anyData() -> Data {
    .init("any data".utf8)
}

func anyId() -> String {
    UUID().uuidString
}

func anyName() -> String {
    "name \(anyId())"
}

func response(code: Int) -> HTTPURLResponse {
    .init(
        url: anyURL(),
        statusCode: code,
        httpVersion: nil,
        headerFields: nil
    )!
}

func anyUrlRequest() -> URLRequest {
    var request = URLRequest(url: anyURL())
    request.httpMethod = "PUT"
    return request
}
