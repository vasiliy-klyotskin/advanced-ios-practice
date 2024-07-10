//
//  PokemonListAcceptanceTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 8/16/23.
//

import XCTest
@testable import Pokepedia_iOS_App
import Pokepedia_iOS
import Pokepedia

final class PokemonListAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteListWhenUserHasConnectivity() {
        let list = launch(httpClient: .online(response), store: .empty)
        
        XCTAssertEqual(list.numberOfRenderedListImageViews(), 2)
        XCTAssertEqual(list.renderedListImageData(at: 0), makeImageData0())
        XCTAssertEqual(list.renderedListImageData(at: 1), makeImageData1())
        XCTAssertTrue(list.canLoadMore)
        
        list.simulateLoadMoreListAction()

        XCTAssertEqual(list.numberOfRenderedListImageViews(), 3)
        XCTAssertEqual(list.renderedListImageData(at: 0), makeImageData0())
        XCTAssertEqual(list.renderedListImageData(at: 1), makeImageData1())
        XCTAssertEqual(list.renderedListImageData(at: 2), makeImageData2())
        XCTAssertTrue(list.canLoadMore)

        list.simulateLoadMoreListAction()

        XCTAssertEqual(list.numberOfRenderedListImageViews(), 3)
        XCTAssertEqual(list.renderedListImageData(at: 0), makeImageData0())
        XCTAssertEqual(list.renderedListImageData(at: 1), makeImageData1())
        XCTAssertEqual(list.renderedListImageData(at: 2), makeImageData2())
        XCTAssertFalse(list.canLoadMore)
    }
    
    func test_onLaunch_displaysCachedRemoteListWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryPokemonListStore.empty
        
        let onlineList = launch(httpClient: .online(response), store: sharedStore)
        onlineList.simulatePokemonListItemViewVisible(at: 0)
        onlineList.simulatePokemonListItemViewVisible(at: 1)
        onlineList.simulateLoadMoreListAction()
        onlineList.simulatePokemonListItemViewVisible(at: 2)
        
        let offlineList = launch(httpClient: .offline, store: sharedStore)
        
        XCTAssertEqual(offlineList.numberOfRenderedListImageViews(), 3)
        XCTAssertEqual(offlineList.renderedListImageData(at: 0), makeImageData0())
        XCTAssertEqual(offlineList.renderedListImageData(at: 1), makeImageData1())
        XCTAssertEqual(offlineList.renderedListImageData(at: 2), makeImageData2())
    }
    
    func test_onLaunch_displaysEmptyListWhenUserHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedListImageViews(), 0)
    }
    
    func test_onEnteringBackground_deletesExpiredListCache() {
        let store = InMemoryPokemonListStore.withExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNil(try store.retrieve(), "Expected to delete expired cache")
    }
    
    func test_onEnteringBackground_keepsNonExpiredListCache() {
        let store = InMemoryPokemonListStore.withNonExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNotNil(try store.retrieve(), "Expected to keep non-expired cache")
    }
    
    func test_onSelectItem_transfersToPokemonDetail() {
        let list = launch(httpClient: .online(response), store: .empty)
        let selectedPokemonId = 0
        
        list.simulateItemSelection(at: selectedPokemonId)
        RunLoop.main.run(until: .init())
        
        let detail = list.navigationController?.viewControllers.last as? ListViewController
        let title = detail?.title
        XCTAssertEqual(title, name(for: selectedPokemonId))
    }
    
    // MARK: - Helpers
    
    private func launch(
        httpClient: HTTPClientStub,
        store: InMemoryPokemonListStore
    ) -> ListViewController {
        let sut = SceneDelegate(
            scheduler: .immediateOnMainQueue,
            listStore: store,
            detailStore: InMemoryDetailPokemonStore(),
            httpClient: httpClient
        )
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let list = nav?.topViewController as! ListViewController
        list.simulateAppearance()
        return list
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/image-0": return makeImageData0()
        case "/image-1": return makeImageData1()
        case "/image-2": return makeImageData2()
            
        case "/list" where url.query?.contains("after_id=-1") == true:
            return makeFirstListPageData()
            
        case "/list" where url.query?.contains("after_id=1") == true:
            return makeSecondListPageData()
            
        case "/list" where url.query?.contains("after_id=2") == true:
            return makeLastEmptyListPageData()
            
        default:
            return Data()
        }
    }
    
    private func makeImageData0() -> Data { UIImage.make(withColor: .red).pngData()! }
    private func makeImageData1() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImageData2() -> Data { UIImage.make(withColor: .blue).pngData()! }
    
    private func makeFirstListPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            itemJson(id: 0, iconUrl: "http://list.com/image-0"),
            itemJson(id: 1, iconUrl: "http://list.com/image-1")
        ])
    }
    
    private func makeSecondListPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            itemJson(id: 2, iconUrl: "http://list.com/image-2"),
        ])
    }
    
    private func makeLastEmptyListPageData() -> Data {
        try! JSONSerialization.data(withJSONObject: [] as [Any])
    }
    
    private func itemJson(id: Int, iconUrl: String) -> [String: Any] {
        [
            "id": id,
            "iconUrl": iconUrl,
            "name": name(for: id),
            "physicalType": [
                "color": "any",
                "name": "any"
            ]
        ]
    }
    
    private func name(for id: Int) -> String {
        "name-\(id)"
    }
    
    private func enterBackground(with store: InMemoryPokemonListStore) {
        let sut = SceneDelegate(scheduler: .immediateOnMainQueue, listStore: store, detailStore: InMemoryDetailPokemonStore(), httpClient: HTTPClientStub.offline)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
}
