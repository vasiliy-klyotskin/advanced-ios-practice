//
//  WeakProxy.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/30/23.
//

import Pokepedia

final class WeakProxy<T: AnyObject> {
    weak var object: T?
    
    init(_ object: T?) {
        self.object = object
    }
}
