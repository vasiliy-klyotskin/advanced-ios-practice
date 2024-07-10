//
//  File.swift
//  
//
//  Created by Vasiliy Klyotskin on 8/11/23.
//

import Foundation
import Vapor

struct DetailPokemonDTO: Codable, Content {
    let imageUrl: URL
    let id: Int
    let name: String
    let genus: String
    let flavorText: String
    let abilities: [AbilityDTO]
}

struct AbilityDTO: Codable {
    let title: String
    let subtitle: String
    let damageClass: String
    let damageClassColor: String
    let type: String
    let typeColor: String
}
