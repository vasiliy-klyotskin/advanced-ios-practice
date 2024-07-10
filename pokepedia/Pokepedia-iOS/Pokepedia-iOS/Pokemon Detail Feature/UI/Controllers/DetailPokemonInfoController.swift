//
//  DetailPokemonInfoController.swift
//  Pokepedia-iOS
//
//  Created by Vasiliy Klyotskin on 7/27/23.
//

import UIKit
import Pokepedia

public final class DetailPokemonInfoController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: DetailPokemonInfoViewModel
    private let onImageRequest: () -> Void
    private var cell: DetailPokemonInfoCell?
    
    public init(viewModel: DetailPokemonInfoViewModel, onImageRequest: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onImageRequest = onImageRequest
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.configure(with: viewModel)
        cell?.onReload = onImageRequest
        onImageRequest()
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cell?.makeImageContainerCircular()
    }
}

extension DetailPokemonInfoController: ResourceLoadingView {
    public func display(loadingViewModel: LoadingViewModel) {
        cell?.display(isLoading: loadingViewModel.isLoading)
    }
}

extension DetailPokemonInfoController: ResourceErrorView {
    public func display(errorViewModel: ErrorViewModel) {
        cell?.display(reload: errorViewModel.needToShowError)
    }
}

extension DetailPokemonInfoController: ResourceView {
    public func display(viewModel image: UIImage) {
        cell?.display(image: image)
    }
}
