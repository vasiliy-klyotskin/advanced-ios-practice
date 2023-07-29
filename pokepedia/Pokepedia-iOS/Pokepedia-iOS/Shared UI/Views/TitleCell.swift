//
//  TitleCell.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/28/23.
//

import UIKit

public final class TitleCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet private var content: UIView!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadFromNib()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        content.fit(in: contentView)
        label.adjustsFontForContentSizeCategory = true
        label.font = .standard(size: .title, weight: .bold)
    }
    
    public func set(title: String) {
        label.text = title
    }
}
