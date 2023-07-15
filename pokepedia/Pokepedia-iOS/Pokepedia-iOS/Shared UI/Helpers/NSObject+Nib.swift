//
//  NSObject+Nib.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/15/23.
//

import Foundation

public extension NSObject {
    func loadFromNib() {
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed(String(describing: Self.self), owner: self)
    }
}
