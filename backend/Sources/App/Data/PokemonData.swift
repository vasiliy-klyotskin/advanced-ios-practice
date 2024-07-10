//
//  File.swift
//  
//
//  Created by Василий Клецкин on 8/14/23.
//

import Foundation
import LoremSwiftum

final class PokemonData {
    static let shared: PokemonData = .init()
    private static let ids = 1...1000
    
    private let pokemonList: PokemonListDTO
    private let pokemonDetails: [Int: DetailPokemonDTO]
    
    init() {
        let generatedPokemons = Self.generatePokemons()
        self.pokemonList = generatedPokemons.0
        self.pokemonDetails = generatedPokemons.1
    }
    
    func detail(for id: Int) -> DetailPokemonDTO? {
        pokemonDetails[id]
    }
    
    func paginated(after id: Int?, limit: Int) -> PokemonListDTO {
        var startIndex: Int
        if let id = id, id >= 0 {
            startIndex = id
        }
        else {
            startIndex = 0
        }
        guard startIndex < pokemonList.count else { return [] }
        startIndex = max(startIndex, 0)
        let endIndex = min(startIndex + limit, pokemonList.count)
        guard endIndex >= startIndex + 1 else { return [] }
        let paginatedList = Array(pokemonList[startIndex..<endIndex])
        return paginatedList
    }
    
    func fullPokemonList() -> PokemonListDTO {
        pokemonList
    }
    
    private static func generatePokemons() -> (PokemonListDTO, [Int: DetailPokemonDTO]) {
        var generatedPokemonList: PokemonListDTO = []
        var generatedPokemonDetails: [Int: DetailPokemonDTO] = [:]
        for id in ids {
            let physicalType = PhysicalType.random
            let specialType = SpecialType.random
            let detailPokemon = DetailPokemonDTO(
                imageUrl: detailImageUrl(for: id),
                id: id,
                name: Lorem.firstName,
                genus: Lorem.sentences(1),
                flavorText: Lorem.sentences(3..<6),
                abilities: generateAbilities()
            )
            generatedPokemonList.append(.init(
                id: id,
                name: detailPokemon.name,
                iconUrl: iconImageUrl(for: id),
                physicalType: .init(
                    color: getColorHexCode(for: physicalType.rawValue),
                    name: physicalType.rawValue.uppercased()
                ),
                specialType: specialType.map {
                    .init(color: getColorHexCode(for: $0.rawValue), name: $0.rawValue.uppercased())
                }
            ))
            generatedPokemonDetails[id] = detailPokemon
        }
        return (generatedPokemonList, generatedPokemonDetails)
    }
    
    private static func generateAbilities() -> [AbilityDTO] {
        (0..<Int.random(in: 3...12)).map { _ in
            let damageClass = PokemonDamageClass.random
            let physType = PhysicalType.allCases.map { $0.rawValue }
            let specialType = SpecialType.allCases.map { $0.rawValue }
            let types = physType + specialType
            let type = types.randomElement()!
            return .init(
                title: Lorem.firstName,
                subtitle: Lorem.sentence,
                damageClass: damageClass.rawValue.uppercased(),
                damageClassColor: damageClass.color(),
                type: type.uppercased(),
                typeColor: getColorHexCode(for: type)
            )
        }
    }
}

fileprivate enum PhysicalType: String, CaseIterable {
    case normal, fighting, flying, ground, rock, bug, steel
    
    static var random: PhysicalType {
        allCases.randomElement()!
    }
}

fileprivate enum SpecialType: String, CaseIterable {
    case fire, water, grass, electric, psychic, ice, poison, ghost, dragon, dark, fairy
    
    static var random: SpecialType? {
        (allCases + [nil, nil, nil, nil]).randomElement()?.flatMap { $0 }
    }
}

enum PokemonDamageClass: String, CaseIterable {
    case physical, special, status, other
    
    static var random: PokemonDamageClass {
        allCases.randomElement()!
    }
    
    func color() -> String {
        switch self {
        case .physical:
            return "FF0000"
        case .special:
            return "0000FF"
        case .status:
            return "800080"
        case .other:
            return "008000"
        }
    }
}

fileprivate func getColorHexCode(for pokemonType: String) -> String {
    switch pokemonType.lowercased() {
        case "fire":
            return "FF1A00"
        case "water":
            return "0099FF"
        case "grass":
            return "00CC00"
        case "electric":
            return "FFCC00"
        case "psychic":
            return "FF007F"
        case "normal":
            return "A8A878"
        case "fighting":
            return "C03028"
        case "flying":
            return "A890F0"
        case "poison":
            return "A040A0"
        case "ground":
            return "E0C068"
        case "rock":
            return "B8A038"
        case "bug":
            return "A8B820"
        case "ice":
            return "98D8D8"
        case "steel":
            return "B8B8D0"
        case "ghost":
            return "705898"
        case "dragon":
            return "7038F8"
        case "dark":
            return "705848"
        case "fairy":
            return "EE99AC"
        default:
            return "000000"
    }
}

fileprivate func iconImageUrl(for id: Int) -> URL {
    let stringUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    return URL(string: stringUrl)!
}

fileprivate func detailImageUrl(for id: Int) -> URL {
    let stringUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    return URL(string: stringUrl)!
}
