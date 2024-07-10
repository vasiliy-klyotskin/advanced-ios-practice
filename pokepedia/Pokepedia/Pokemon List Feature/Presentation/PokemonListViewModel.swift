//
//  PokemonListViewModel.swift
//  Pokepedia
//
//  Created by Vasiliy Klyotskin on 6/2/23.
//

import Foundation

public typealias PokemonListViewModel<Color: Hashable> = [ListPokemonItemViewModel<Color>]

public struct ListPokemonItemViewModel<Color: Hashable>: Hashable {
    public let name: String
    public let id: String
    public let physicalType: String
    public let specialType: String?
    public let physicalTypeColor: Color
    public let specialTypeColor: Color?
    
    public var shouldShowSpecialType: Bool {
        specialType != nil
    }
}
