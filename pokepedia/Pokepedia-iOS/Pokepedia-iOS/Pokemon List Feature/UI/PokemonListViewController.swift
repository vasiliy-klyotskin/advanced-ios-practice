//
//  PokemonListViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 5/29/23.
//

import UIKit
import Pokepedia

public final class PokemonListViewController: UITableViewController, ResourceLoadingView, ResourceErrorView {
    private var onRefresh: (() -> Void)?
    
    let errorView = ErrorView()
    
    public convenience init(onRefresh: @escaping () -> Void) {
        self.init()
        self.onRefresh = onRefresh
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refresh()
    }
    
    @objc private func refresh() {
        onRefresh?()
    }
    
    public func display(loadingViewModel: LoadingViewModel) {
        if loadingViewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    public func display(errorViewModel: ErrorViewModel) {
        errorView.errorMessageLabel.text = errorViewModel.errorMessage
    }
}

final class ErrorView: UIView {
    let errorMessageLabel = UILabel()
}
