//
//  PokemonListViewController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 5/29/23.
//

import UIKit

public final class PokemonListViewController: UITableViewController {
    private var onRefresh: (() -> Void)?
    
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
}
