//
//  PokemonListUIComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 5/28/23.
//

import Pokepedia
import UIKit
import Combine

public final class PokemonListViewController: UITableViewController {
    private var onRefresh: (() -> Void)?
    
    convenience init(onRefresh: @escaping () -> Void) {
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

public enum PokemonListUIComposer {
    public static func compose(loader: @escaping () -> AnyPublisher<PokemonList, Error>) -> PokemonListViewController {
        let adapter = PokemonListLoadingAdapter(loader: loader)
        let controller = PokemonListViewController(onRefresh: adapter.load)
        controller.title = PokemonListPresenter.title
        return controller
    }
}

final class PokemonListLoadingAdapter {
    private let loader: () -> AnyPublisher<PokemonList, Error>
    private var cancellable: AnyCancellable?
    private var isLoading = false
    
    init(loader: @escaping () -> AnyPublisher<PokemonList, Error>) {
        self.loader = loader
    }
    
    func load() {
        guard !isLoading else { return }
        isLoading = true
        cancellable = loader().sink(
            receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            },
            receiveValue: { _ in }
        )
    }
}
