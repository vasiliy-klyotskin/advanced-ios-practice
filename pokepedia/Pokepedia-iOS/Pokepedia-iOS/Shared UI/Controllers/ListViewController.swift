//
//  ListViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/26/23.
//

import Pokepedia
import UIKit

public final class ListViewController: UITableViewController, ResourceLoadingView, ResourceErrorView {
    private var onRefresh: (() -> Void)?
    
    let errorView = ErrorView()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
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
        tableView.tableHeaderView = errorView.makeContainer()
        refresh()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeTableHeaderToFit()
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
        errorView.message = errorViewModel.errorMessage
    }

    public func display(controllers: [CellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(controllers, toSection: 0)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}
