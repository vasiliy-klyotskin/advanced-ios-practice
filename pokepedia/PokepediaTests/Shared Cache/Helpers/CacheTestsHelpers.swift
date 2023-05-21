//
//  CacheTestsHelpers.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 5/21/23.
//

import XCTest

extension XCTestCase {
    func anyKey() -> String {
        anyId()
    }
    
    func validationStub(
        file: StaticString = #filePath,
        line: UInt = #line,
        expired: Bool,
        timestamp: Date
    ) -> (Date) -> Bool {
        { actualTimestamp in
            XCTAssertEqual(
                actualTimestamp,
                timestamp,
                "Validation should be called with right timestamp",
                file: file,
                line: line
            )
            return !expired
        }
    }
}
