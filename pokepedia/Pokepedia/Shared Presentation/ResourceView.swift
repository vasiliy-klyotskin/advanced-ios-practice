//
//  ResourceView.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/22/23.
//

import Foundation

public protocol ResourceView {
    associatedtype ViewModel
    func display(viewModel: ViewModel)
}

public protocol ResourceLoadingView {
    func display(loadingViewModel: LoadingViewModel)
}

public struct LoadingViewModel {
    public let isLoading: Bool
}

public protocol ResourceErrorView {
    func display(errorViewModel: ErrorViewModel)
}

public struct ErrorViewModel {
    public let errorMessage: String?
    
    public var needToShowError: Bool { errorMessage != nil }
}
