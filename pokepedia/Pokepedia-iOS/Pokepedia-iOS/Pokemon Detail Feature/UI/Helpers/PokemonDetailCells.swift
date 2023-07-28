//
//  PokemonDetailCells.swift
//  Pokepedia-iOS
//
//  Created by Василий Клецкин on 7/28/23.
//

import UIKit

public enum PokemonDetailCells {
    public static func register(for controller: ListViewController) {
        controller.tableView.register(TitleCell.self, forCellReuseIdentifier: titleId)
        controller.tableView.register(DetailPokemonInfoCell.self, forCellReuseIdentifier: infoId)
        controller.tableView.register(DetailPokemonAbilityCell.self, forCellReuseIdentifier: abilityId)
    }
    
    private static var titleId: String {
        String(describing: TitleCell.self)
    }
    
    private static var infoId: String {
        String(describing: DetailPokemonInfoCell.self)
    }
    
    private static var abilityId: String {
        String(describing: DetailPokemonAbilityCell.self)
    }
}
