//
//  DetailPokemonRemote.swift
//  Pokepedia
//
//  Created by Василий Клецкин on 7/25/23.
//

import Foundation

public struct DetailPokemonRemote: Decodable {
    let imageUrl: URL
    let id: Int
    let name: String
    let genus: String
    let flavorText: String
    let abilities: [Ability]
    
    struct Ability: Decodable {
        let title: String
        let subtitle: String
        let damageClass: String
        let damageClassColor: String
        let type: String
        let typeColor: String
    }
}
