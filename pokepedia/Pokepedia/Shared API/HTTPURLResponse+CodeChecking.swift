//
//  HTTPURLResponse+CodeChecking.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 5/16/23.
//

import Foundation

extension HTTPURLResponse {
    var isOk: Bool { statusCode == 200 }
}
