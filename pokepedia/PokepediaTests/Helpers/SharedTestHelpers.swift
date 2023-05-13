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
