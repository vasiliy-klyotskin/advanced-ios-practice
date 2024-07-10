//
//  WeakProxy.swift
//  Pokepedia-iOS-App
//
//  Created by Vasiliy Klyotskin on 5/30/23.
//

import Pokepedia

final class WeakProxy<T: AnyObject> {
    weak var object: T?
    
    init(_ object: T?) {
        self.object = object
    }
}

extension WeakProxy: ResourceLoadingView where T: ResourceLoadingView {
    func display(loadingViewModel: LoadingViewModel) {
        object?.display(loadingViewModel: loadingViewModel)
    }
}

extension WeakProxy: ResourceErrorView where T: ResourceErrorView {
    func display(errorViewModel: ErrorViewModel) {
        object?.display(errorViewModel: errorViewModel)
    }
}

extension WeakProxy: ResourceView where T: ResourceView {
    func display(viewModel: T.ViewModel) {
        object?.display(viewModel: viewModel)
    }
}
