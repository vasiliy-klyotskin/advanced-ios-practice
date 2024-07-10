//
//  File.swift
//  
//
//  Created by Василий Клецкин on 8/15/23.
//

import Foundation

final class PokemonListTestData {
    static let data: PokemonListDTO = (0..<5).map { item(for: $0) }
    
    private static func item(for index: Int) -> ListPokemonItemDTO {
        .init(
            id: id(for: index),
            name: name(for: index),
            iconUrl: imageUrl(for: index),
            physicalType: physicalType(for: index),
            specialType: specialType(for: index)
        )
    }

    private static func id(for index: Int) -> Int {
        [
            0,
            1,
            2,
            3,
            4
        ][index]
    }

    private static func name(for index: Int) -> String {
        [
            "Name A",
            "Name B",
            "Name C",
            "Name D",
            "Name E",
        ][index]
    }

    private static func imageUrl(for index: Int) -> URL {
        [
            URL(string: "https://item-url-0.com")!,
            URL(string: "https://item-url-1.com")!,
            URL(string: "https://item-url-2.com")!,
            URL(string: "https://item-url-3.com")!,
            URL(string: "https://item-url-4.com")!
        ][index]
    }

    private static func physicalType(for index: Int) -> ListPokemonTypeDTO {
        [
            .init(color: "000000", name: "Color name 0"),
            .init(color: "000010", name: "Color name 1"),
            .init(color: "000100", name: "Color name 2"),
            .init(color: "001000", name: "Color name 3"),
            .init(color: "010000", name: "Color name 4"),
        ][index]
    }

    private static func specialType(for index: Int) -> ListPokemonTypeDTO? {
        [
            .init(color: "900000", name: "Color name 10"),
            nil,
            nil,
            .init(color: "901000", name: "Color name 13"),
            .init(color: "910000", name: "Color name 14"),
        ][index]
    }
}
