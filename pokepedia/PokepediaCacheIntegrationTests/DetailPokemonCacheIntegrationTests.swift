//
//  DetailPokemonCacheIntegrationTests.swift
//  PokepediaCacheIntegrationTests
//
//  Created by Василий Клецкин on 8/22/23.
//
import XCTest
import Pokepedia

final class DetailPokemonCacheIntegrationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    // MARK: - LocalPokemonListLoader (CoreDataPokemonListStore) Tests
    
    func test_loadDetail_deliversNoListOnEmptyCache() {
        let detailLoader = makeListLoader()
        
        ids.forEach { id in
            expect(detailLoader, for: id, toLoad: nil)
        }
    }
    
    func test_loadDetail_deliversListSavedOnASeparateInstance() {
        let loaderToPerformSave = makeListLoader()
        let loaderToPerformLoad = makeListLoader()
        
        ids.forEach { id in
            let detail = localDetail(for: id).model

            loaderToPerformSave.save(detail: detail)

            expect(loaderToPerformLoad, for: id, toLoad: detail)
        }
    }

    func test_saveDetail_overridesListSavedOnASeparateInstance() {
        let loaderToPerformFirstSave = makeListLoader()
        let loaderToPerformLastSave = makeListLoader()
        let loaderToPerformLoad = makeListLoader()
        
        ids.forEach { id in
            let firstDetail = localDetail(for: id).model
            let latestDetail = localDetail(for: id).model

            loaderToPerformFirstSave.save(detail: firstDetail)
            loaderToPerformLastSave.save(detail: latestDetail)

            expect(loaderToPerformLoad, for: id, toLoad: latestDetail)
        }
    }

    func test_validateListCache_doesNotDeleteRecentlySavedList() {
        let loaderToPerformSave = makeListLoader()
        let loaderToPerformValidation = makeListLoader()
        let loaderToPerformLoad = makeListLoader()
        let list = pokemonList().model
        
        ids.forEach { id in
            loaderToPerformSave.save(detail: localDetail(for: id).model)
        }
        
        loaderToPerformValidation.validateCache()

        ids.forEach { id in
            expect(loaderToPerformLoad, for: id, toLoad: localDetail(for: id).model)
        }
    }
//
//    func test_validateListCache_deletesListSavedInADistantPast() {
//        let listLoaderToPerformSave = makeListLoader(currentDate: .distantPast)
//        let listLoaderToPerformValidation = makeListLoader(currentDate: Date())
//        let list = pokemonList().model
//
//        save(list, with: listLoaderToPerformSave)
//        validateCache(with: listLoaderToPerformValidation)
//
//        expect(listLoaderToPerformSave, toLoad: nil)
//    }
//
//    // MARK: - LocalImageLoader (CoreDataImageStore) Tests
//
//    func test_loadImageData_deliversSavedDataOnASeparateInstance() {
//        let imageLoaderToPerformSave = makeImageLoader()
//        let imageLoaderToPerformLoad = makeImageLoader()
//        let listLoader = makeListLoader()
//        let list = pokemonList().model
//        let imageUrl = list.first!.imageUrl
//        let dataToSave = Data("any data".utf8)
//
//        save(list, with: listLoader)
//        save(dataToSave, for: imageUrl, with: imageLoaderToPerformSave)
//
//        expect(imageLoaderToPerformLoad, toLoad: dataToSave, for: imageUrl)
//    }
//
//    func test_saveImageData_overridesSavedImageDataOnASeparateInstance() {
//        let imageLoaderToPerformFirstSave = makeImageLoader()
//        let imageLoaderToPerformLastSave = makeImageLoader()
//        let imageLoaderToPerformLoad = makeImageLoader()
//        let feedLoader = makeListLoader()
//        let list = pokemonList().model
//        let imageUrl = list.first!.imageUrl
//        let firstImageData = Data("first".utf8)
//        let lastImageData = Data("last".utf8)
//
//        save(list, with: feedLoader)
//        save(firstImageData, for: imageUrl, with: imageLoaderToPerformFirstSave)
//        save(lastImageData, for: imageUrl, with: imageLoaderToPerformLastSave)
//
//        expect(imageLoaderToPerformLoad, toLoad: lastImageData, for: imageUrl)
//    }
    
    // MARK: - Helpers
    
    private func makeListLoader(
        currentDate: Date = .init(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> LocalDetailPokemonLoader {
        let storeUrl = testSpecificStoreURL()
        let store = try! CoreDataDetailPokemonStore(storeUrl: storeUrl)
        let loader = LocalDetailPokemonLoader(store: store, currentDate: { currentDate })
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return loader
    }
    
    private let ids = [0, 1, 2]
    
//    private func makeImageLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalImageLoader {
//        let storeUrl = testSpecificStoreURL()
//        let store = try! CoreDataPokemonListStore(storeUrl: storeUrl)
//        let loader = LocalImageLoader(store: store)
//        trackForMemoryLeaks(store, file: file, line: line)
//        trackForMemoryLeaks(loader, file: file, line: line)
//        return loader
//    }
    
    private func expect(
        _ sut: LocalDetailPokemonLoader,
        for id: Int,
        toLoad expected: DetailPokemon?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            let loaded = try sut.load(for: id)
            XCTAssertEqual(loaded, expected, file: file, line: line)
        } catch {
            return
        }
    }
    
//    private func save(_ data: Data, for url: URL, with loader: LocalImageLoader, file: StaticString = #filePath, line: UInt = #line) {
//        do {
//            try loader.save(data, for: url)
//        } catch {
//            XCTFail("Expected to save image data successfully, got error: \(error)", file: file, line: line)
//        }
//    }
//
//    private func expect(_ sut: LocalImageLoader, toLoad expectedData: Data, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
//        do {
//            let loadedData = try sut.loadImageData(from: url)
//            XCTAssertEqual(loadedData, expectedData, file: file, line: line)
//        } catch {
//            XCTFail("Expected successful image data result, got \(error) instead", file: file, line: line)
//        }
//    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}
