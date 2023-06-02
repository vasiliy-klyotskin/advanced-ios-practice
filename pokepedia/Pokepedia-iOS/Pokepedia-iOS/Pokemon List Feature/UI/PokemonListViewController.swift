//
//  PokemonListViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 5/29/23.
//

import UIKit
import Pokepedia

public final class PokemonListViewController: UITableViewController, ResourceLoadingView, ResourceErrorView, ResourceView {
    private var onRefresh: (() -> Void)?
    
    let errorView = ErrorView()
    private lazy var dataSource: UITableViewDiffableDataSource<Int, ListPokemonItemViewModel> = {
        .init(tableView: tableView) { (tableView, index, vm) in
            let cell = ListPokemonItemCell()
            cell.idLabel.text = vm.id
            cell.nameLabel.text = vm.name
            cell.physicalTypeLabel.text = vm.physicalType
            cell.specialTypeLabel.text = vm.specialType
            return cell
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

    public func display(resourceViewModel: PokemonListViewModel) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ListPokemonItemViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(resourceViewModel, toSection: 0)
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
