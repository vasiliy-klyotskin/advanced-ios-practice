//
//  PokemonListCacheFacade.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 7/8/23.
//

import Pokepedia

public final class PokemonListCacheFacade {
    private let loader: LocalLoader<PokemonList, PokemonList>
    private let saver: LocalSaver<PokemonList, PokemonList>
    private let validation: LocalValidator
    
    private var key: String { "pokemonList.cache" }
    
    init(
        loader: LocalLoader<PokemonList, PokemonList>,
        saver: LocalSaver<PokemonList, PokemonList>,
        validation: LocalValidator
    ) {
        self.loader = loader
        self.saver = saver
        self.validation = validation
    }
    
    public func loadList() throws -> PokemonList {
        try loader.load(for: key)
    }
    
    public func save(list: PokemonList) {
        saver.save(list, for: key)
    }
    
    public func validate() {
        validation.validate(for: key)
    }
}
