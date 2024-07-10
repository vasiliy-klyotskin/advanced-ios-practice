//
//  PokemonListCells.swift
//  Pokepedia-iOS
//
//  Created by Vasiliy Klyotskin on 7/28/23.
//

import Foundation

public enum PokemonListCells {
    public static func register(for controller: ListViewController) {
        controller.tableView.register(ListPokemonItemCell.self, forCellReuseIdentifier: cellId)
    }
    
    private static var cellId: String {
        String(describing: ListPokemonItemCell.self)
    }
}
