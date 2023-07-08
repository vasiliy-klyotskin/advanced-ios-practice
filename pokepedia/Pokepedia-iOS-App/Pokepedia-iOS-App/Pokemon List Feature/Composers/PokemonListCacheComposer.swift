//
//  PokemonListCacheComposer.swift
//  Pokepedia-iOS-App
//
//  Created by Василий Клецкин on 7/8/23.
//

import Pokepedia
import Foundation

public enum PokemonListCacheComposer {
    public static func compose(
        timestamp: @escaping () -> Date = Date.init,
        loadMomentDate: @escaping () -> Date = Date.init
    ) -> PokemonListCacheFacade {
        let store = InMemoryStore<PokemonList>()
        return PokemonListCacheFacade(
            loader: .init(
                store: store,
                mapping: { $0 },
                validation: against(loadMomentDate: loadMomentDate)
            ),
            saver: .init(
                store: store,
                mapping: { $0 },
                current: timestamp
            ),
            validation: .init(
                store: store,
                validation: against(loadMomentDate: loadMomentDate)
            )
        )
    }
    
    private static func against(loadMomentDate: @escaping () -> Date) -> (Date) -> Bool {
        { timestamp in
            PokemonListCachePolicy.validate(timestamp, against: loadMomentDate())
        }
    }
}
