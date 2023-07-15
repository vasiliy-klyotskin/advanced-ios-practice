//
//  PokemonListViewModel.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 6/2/23.
//

import Foundation

public typealias PokemonListViewModel = [ListPokemonItemViewModel]

public struct ListPokemonItemViewModel: Hashable {
    public let name: String
    public let id: String
    public let physicalType: String
    public let specialType: String?
    
    public var shouldShowSpecialType: Bool {
        specialType != nil
    }
}
