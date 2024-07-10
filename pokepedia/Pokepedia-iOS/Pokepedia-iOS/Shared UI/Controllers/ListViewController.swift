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
    private var onViewDidLoad: ((ListViewController) -> Void)?
    private var isAppeared = false
    
    let errorView = ErrorView()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
        }
    }()
    
    public convenience init(
        onRefresh: @escaping () -> Void,
        onViewDidLoad: @escaping (ListViewController) -> Void = { _ in }
    ) {
        self.init()
        self.onRefresh = onRefresh
        self.onViewDidLoad = onViewDidLoad
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.tableHeaderView = errorView.makeContainer()
        onViewDidLoad?(self)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if !isAppeared {
            refresh()
            isAppeared = true
        }
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
        tableView.sizeTableHeaderToFit()
    }

    public func display(sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dl = cellController(at: indexPath)?.delegate
        return dl?.tableView?(tableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
    }
    
    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}
