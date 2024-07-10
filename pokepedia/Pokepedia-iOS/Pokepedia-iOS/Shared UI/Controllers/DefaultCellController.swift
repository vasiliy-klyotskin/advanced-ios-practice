//
//  TitleCellController.swift
//  Pokepedia-iOS
//
//  Created by Vasiliy Klyotskin on 7/28/23.
//

import UIKit

public final class DefaultCellController<Cell: UITableViewCell>: NSObject, UITableViewDataSource {
    private let configure: (Cell) -> Void
    
    public init(configure: @escaping (Cell) -> Void) {
        self.configure = configure
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell()
        configure(cell)
        return cell
    }
}
