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

final class ErrorView: UIView {
    let errorMessageLabel = UILabel()
}

public final class ListPokemonItemCell: UITableViewCell {
    let nameLabel = UILabel()
    let idLabel = UILabel()
    let specialTypeLabel = UILabel()
    let physicalTypeLabel = UILabel()
}


public final class ListPokemonItemViewController: NSObject, UITableViewDataSource {
    let viewModel: ListPokemonItemViewModel
    
    public init(viewModel: ListPokemonItemViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListPokemonItemCell()
        cell.idLabel.text = viewModel.id
        cell.nameLabel.text = viewModel.name
        cell.physicalTypeLabel.text = viewModel.physicalType
        cell.specialTypeLabel.text = viewModel.specialType
        return cell
    }
}
