//
//  LoadMoreCellController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 8/9/23.
//

import UIKit
import Pokepedia

public class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let cell = LoadMoreCell()
    private let callback: () -> Void
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
        callback()
    }
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(errorViewModel: ErrorViewModel) {
        
    }
    
    public func display(loadingViewModel: LoadingViewModel) {
        cell.isLoading = loadingViewModel.isLoading
    }
}
