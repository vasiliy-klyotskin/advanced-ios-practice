//
//  LoadingResourcePresenter.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/22/23.
//

import Foundation

public protocol ResourceView {
    
}

public protocol ResourceLoadingView {
    func display(loadingViewModel: Bool)
}

public protocol ResourceErrorView {
    func display(errorViewModel: String?)
}

public final class LoadingResourcePresenter {
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView
    
    public init(
        view: ResourceView,
        errorView: ResourceErrorView,
        loadingView: ResourceLoadingView
    ) {
        self.errorView = errorView
        self.loadingView = loadingView
    }
    
    private static var loadError: String {
        NSLocalizedString(
            "GENERIC_CONNECTION_ERROR",
            tableName: "Shared",
            bundle: Bundle(for: Self.self),
            comment: "Error message displayed when we can't load the resource from the server"
        )
    }
    
    public func didStartLoading() {
        errorView.display(errorViewModel: nil)
        loadingView.display(loadingViewModel: true)
    }
    
    public func didFinishLoadingWithError() {
        errorView.display(errorViewModel: Self.loadError)
        loadingView.display(loadingViewModel: false)
    }
}
