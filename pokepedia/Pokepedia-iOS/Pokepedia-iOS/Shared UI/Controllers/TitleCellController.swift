//
//  TitleCellController.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/28/23.
//

import UIKit

public final class TitleCellController: NSObject, UITableViewDataSource {
    private let viewModel: String
    
    public init(viewModel: String) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TitleCell()
        cell.set(title: viewModel)
        return cell
    }
}
