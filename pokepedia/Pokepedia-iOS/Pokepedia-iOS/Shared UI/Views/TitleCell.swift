//
//  TitleCell.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/28/23.
//

import UIKit

final class TitleCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet private var content: UIView!
    
    convenience init() {
        self.init(frame: .zero)
        loadFromNib()
        configureUI()
    }
    
    private func configureUI() {
        content.fit(in: contentView)
        label.font = .standard(size: .title, weight: .semibold)
    }
    
    func set(title: String) {
        label.text = title
    }
}
