//
//  UIImage+Creation.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/27/23.
//

import UIKit

private struct InvalidDataError: Error {}

public extension UIImage {
    static func tryFrom(data: Data) throws -> UIImage {
        if let image = UIImage(data: data) {
            return image
        } else {
            throw InvalidDataError()
        }
    }
}
