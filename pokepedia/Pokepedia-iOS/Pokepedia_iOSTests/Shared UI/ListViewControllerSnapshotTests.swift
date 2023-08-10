//
//  ListViewControllerSnapshotTests.swift
//  Pokepedia_iOSTests
//
//  Created by Василий Клецкин on 7/27/23.
//

import XCTest
import Combine
import Pokepedia_iOS
@testable import Pokepedia

final class ListControllerSnapshotTests: XCTestCase {
    func test_initialState() {
        let sut = makeSut()
        
        assertDefaultSnapshot(sut: sut, key: "LIST_EMPTY")
    }
    
    func test_listIsLoadingSnapshot() {
        let sut = makeSut()
        
        sut.display(loadingViewModel: .init(isLoading: true))
        
        assertDefaultSnapshot(sut: sut, key: "LIST_LOADING")
    }
    
    func test_listLoadedWithErrorSnapshot() {
        let sut = makeSut()
        
        sut.display(errorViewModel: .init(errorMessage: "Some multiline \nerror message text"))
        
        assertDefaultSnapshot(sut: sut, key: "LIST_ERROR")
    }
    
    func test_loadMoreView_errorState() {
        let sut = makeSut()

        sut.display(sections: loadMore(with: .error("Connection error: No internet connection available at the moment.")))
        
        assertDefaultSnapshot(sut: sut, key: "LOAD_MORE_ERROR")
    }
    
    func test_loadMoreView_loadingState() {
        let sut = makeSut()

        sut.display(sections: loadMore(with: .loading))
        
        assertDefaultSnapshot(sut: sut, key: "LOAD_MORE_LOADING")
    }
    
    // MARK: - Helpers
    
    private func makeSut(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ListViewController {
        let sut = ListViewController(onRefresh: {})
        sut.loadViewIfNeeded()
        sut.tableView.showsVerticalScrollIndicator = false
        sut.tableView.showsHorizontalScrollIndicator = false
        return sut
    }
    
    private enum LoadMoreState {
        case loading
        case error(String)
    }
    
    private func loadMore(with state: LoadMoreState) -> [CellController] {
        let controller = LoadMoreCellController(callback: {})
        switch state {
        case .loading:
            controller.display(loadingViewModel: .init(isLoading: true))
        case .error(let message):
            controller.display(errorViewModel: .init(errorMessage: message))
        }
        return [CellController(id: UUID(), controller)]
    }
}
