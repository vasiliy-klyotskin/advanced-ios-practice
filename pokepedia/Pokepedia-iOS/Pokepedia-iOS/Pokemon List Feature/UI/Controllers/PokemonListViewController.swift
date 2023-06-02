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
    
    let errorView = PokemonListErrorView()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, ListPokemonItemViewController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.tableView(tableView, cellForRowAt: index)
        }
    }()
    
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

    public func display(controllers: [ListPokemonItemViewController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ListPokemonItemViewController>()
        snapshot.appendSections([0])
        snapshot.appendItems(controllers, toSection: 0)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}
