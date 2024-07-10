//
//  UITableView+Dequeue.swift
//  Pokepedia-iOS
//
//  Created by Vasiliy Klyotskin on 7/28/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
