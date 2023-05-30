//
//  SharedTestHelpers.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 5/30/23.
//

import Foundation

func anyNSError() -> NSError {
    .init(domain: "any domain", code: 1)
}
