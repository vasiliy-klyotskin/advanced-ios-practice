//
//  LoadingResourcePresenter.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 5/22/23.
//

import Foundation

public final class LoadingResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapping = (Resource) throws -> View.ViewModel
    
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
    
    public init(
        view: View,
        loadingView: ResourceLoadingView,
        errorView: ResourceErrorView
    ) where Resource == View.ViewModel {
        self.view = view
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapping = { $0 }
    }
    
    public static var loadError: String {
        NSLocalizedString(
            "GENERIC_CONNECTION_ERROR",
            tableName: "Shared",
            bundle: Bundle(for: Self.self),
            comment: "Error message displayed when we can't load the resource from the server"
        )
    }
    
    public func didStartLoading() {
        errorView.display(errorViewModel: .init(errorMessage: nil))
        loadingView.display(loadingViewModel: .init(isLoading: true))
    }
    
    public func didFinishLoadingWithError() {
        errorView.display(errorViewModel: .init(errorMessage: Self.loadError))
        loadingView.display(loadingViewModel: .init(isLoading: false))
    }
    
    public func didFinishLWithResource(_ resource: Resource) {
        loadingView.display(loadingViewModel: .init(isLoading: false))
        if let mapped = try? mapping(resource) {
            view.display(viewModel: mapped)
        } else {
            errorView.display(errorViewModel: .init(errorMessage: Self.loadError))
        }
    }
}
