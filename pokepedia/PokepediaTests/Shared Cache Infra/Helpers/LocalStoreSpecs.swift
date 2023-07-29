//
//  LocalStoreSpecs.swift
//  PokepediaTests
//
//  Created by Василий Клецкин on 7/29/23.
//

import Pokepedia

typealias LocalStore = LocalSaverStore & LocalLoaderStore & LocalValidatorStore

protocol LocalStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffects()
    func test_retrieve_deliversCacheOnNotEmpty()
    func test_insert_overridesPreviouslyInsertedCache()
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_deletesPreviouslyInsertedCache()
    func test_retrieve_deliversDifferentCacheOnDifferentKey()
    func test_delete_deletesDifferentCacheOnDifferentKey()
}
