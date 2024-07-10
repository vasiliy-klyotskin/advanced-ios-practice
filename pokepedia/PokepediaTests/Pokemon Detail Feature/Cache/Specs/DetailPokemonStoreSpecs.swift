//
//  CoreDataDetailPokemonStoreSpecs.swift
//  PokepediaTests
//
//  Created by Vasiliy Klyotskin on 8/22/23.
//

import Foundation

protocol DetailPokemonStoreSpecs {
    func test_retrieveForId_returnsEmptyOnEmptyCache()
    func test_retrieveForValidation_returnsEmptyOnEmptyCache() throws
    func test_retrieveForId_returnsCacheForIdWhenCacheIsNotEmpty()
    func test_retrieveForValidation_returnsValidationRetrievalWhenCacheIsNotEmpty() throws
    func test_deleteForId_deletesCacheForParticularId()
    func test_deleteForId_affectsValidationRetrieval() throws
    func test_deleteAll_removesAllPokemons()
    func test_deleteAll_cauesesValidationRetrievalsAreEmpty() throws
}
