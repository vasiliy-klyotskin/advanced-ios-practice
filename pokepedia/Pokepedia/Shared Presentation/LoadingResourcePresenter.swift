//
//  LoadingResourcePresenter.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/22/23.
//

import Foundation

public protocol ResourceView {
    associatedtype ViewModel
    func display(resourceViewModel: ViewModel)
}

public protocol ResourceLoadingView {
    func display(loadingViewModel: Bool)
}

public protocol ResourceErrorView {
    func display(errorViewModel: String?)
}

public final class LoadingResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapping = (Resource) -> View.ViewModel
    
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView
    private let view: View
    private let mapping: Mapping
    
    public init(
        view: View,
        errorView: ResourceErrorView,
        loadingView: ResourceLoadingView,
        mapping: @escaping Mapping
    ) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.view = view
        self.mapping = mapping
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
    
    public func didFinishLWithResource(_ resource: Resource) {
        loadingView.display(loadingViewModel: false)
        view.display(resourceViewModel: mapping(resource))
    }
}
