//
//  File.swift
//  
//
//  Created by Василий Клецкин on 8/11/23.
//

import Foundation
import Vapor

typealias PokemonListDTO = [ListPokemonItemDTO]

struct ListPokemonItemDTO: Codable, Content {
    let id: Int
    let name: String
    let iconUrl: URL
    let physicalType: ListPokemonTypeDTO
    let specialType: ListPokemonTypeDTO?
}

struct ListPokemonTypeDTO: Codable {
    let color: String
    let name: String
}
