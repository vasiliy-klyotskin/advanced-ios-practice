//
//  LoadMoreCellController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 8/9/23.
//

import UIKit
import Pokepedia

public class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let cell = {
        let cell = LoadMoreCell()
        cell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        return cell
    }()
    
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
        callback()
    }
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(errorViewModel: ErrorViewModel) {
        cell.message = errorViewModel.errorMessage
    }
    
    public func display(loadingViewModel: LoadingViewModel) {
        cell.isLoading = loadingViewModel.isLoading
    }
}
