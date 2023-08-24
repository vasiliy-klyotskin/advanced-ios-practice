//
//  PokemonDetailAcceptanceTests.swift
//  Pokepedia-iOS-AppTests
//
//  Created by Василий Клецкин on 8/23/23.
//

import Foundation

import XCTest
@testable import Pokepedia_iOS_App
import Pokepedia_iOS
import Pokepedia

final class DetailPokemonAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteListWhenUserHasConnectivity() {
        let detail = launch(httpClient: .online(response), store: .empty)
        
        let info = detail.simulatePokemonDetailInfoViewVisible()

        XCTAssertEqual(info?.nameText, detailPokemonName)
        XCTAssertEqual(info?.detailRenderedImage, makeImageData())
    }
    
//    func test_onLaunch_displaysCachedRemoteListWhenCustomerHasNoConnectivity() {
//        let sharedStore = InMemoryPokemonListStore.empty
//
//        let onlineList = launch(httpClient: .online(response), store: sharedStore)
//        onlineList.simulatePokemonListItemViewVisible(at: 0)
//        onlineList.simulatePokemonListItemViewVisible(at: 1)
//        onlineList.simulateLoadMoreListAction()
//        onlineList.simulatePokemonListItemViewVisible(at: 2)
//
//        let offlineList = launch(httpClient: .offline, store: sharedStore)
//
//        XCTAssertEqual(offlineList.numberOfRenderedListImageViews(), 3)
//        XCTAssertEqual(offlineList.renderedListImageData(at: 0), makeImageData0())
//        XCTAssertEqual(offlineList.renderedListImageData(at: 1), makeImageData1())
//        XCTAssertEqual(offlineList.renderedListImageData(at: 2), makeImageData2())
//    }
//
//    func test_onLaunch_displaysEmptyListWhenUserHasNoConnectivityAndNoCache() {
//        let feed = launch(httpClient: .offline, store: .empty)
//
//        XCTAssertEqual(feed.numberOfRenderedListImageViews(), 0)
//    }
//
//    func test_onEnteringBackground_deletesExpiredListCache() {
//        let store = InMemoryPokemonListStore.withExpiredFeedCache
//
//        enterBackground(with: store)
//
//        XCTAssertNil(try store.retrieve(), "Expected to delete expired cache")
//    }
//
//    func test_onEnteringBackground_keepsNonExpiredListCache() {
//        let store = InMemoryPokemonListStore.withNonExpiredFeedCache
//
//        enterBackground(with: store)
//
//        XCTAssertNotNil(try store.retrieve(), "Expected to keep non-expired cache")
//    }
//
//    func test_onSelectItem_transfersToPokemonDetail() {
//        let list = launch(httpClient: .online(response), store: .empty)
//        let selectedPokemonId = 0
//
//        list.simulateItemSelection(at: selectedPokemonId)
//        RunLoop.main.run(until: .init())
//
//        let detail = list.navigationController?.viewControllers.last as? ListViewController
//        let title = detail?.title
//        XCTAssertEqual(title, name(for: selectedPokemonId))
//    }
    
    // MARK: - Helpers
    
    private func launch(
        httpClient: HTTPClientStub,
        store: InMemoryPokemonListStore
    ) -> ListViewController {
        let sut = SceneDelegate(scheduler: .immediateOnMainQueue, store: store, httpClient: httpClient)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()
        let nav = sut.window?.rootViewController as? UINavigationController
        
        let list = nav?.topViewController as! ListViewController
        list.simulateItemSelection(at: detailId)
        RunLoop.main.run(until: .init())
        
        return nav?.topViewController as! ListViewController
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/detail-image-0": return makeImageData()
        case "/detail": return makeDetailData()
        case "/list": return makeListData()
        default: return Data()
        }
    }
    
    private func makeImageData() -> Data { UIImage.make(withColor: .red).pngData()! }
    
    private func makeDetailData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            "abilities": [] as [Any],
            "id": detailId,
            "imageUrl": imageUrl.absoluteString,
            "name": detailPokemonName,
            "genus": "genus",
            "flavorText": "flavor"
        ] as [String : Any])
    }
    
    private func makeListData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [[
            "id": detailId,
            "iconUrl": anyURL().absoluteString,
            "name": "any",
            "physicalType": [
                "color": "any",
                "name": "any"
            ]
        ] as [String : Any]])
    }
    
    private var detailId: Int {
        0
    }
    
    private var detailPokemonName: String {
        "Detail Pokemon Name"
    }

    private var imageUrl: URL {
        URL(string: "http://any-url.com/detail-image-0")!
    }
    
//    private func enterBackground(with store: InMemoryPokemonListStore) {
//        let sut = SceneDelegate(scheduler: .immediateOnMainQueue, store: store, httpClient: HTTPClientStub.offline)
//        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
//    }
}
