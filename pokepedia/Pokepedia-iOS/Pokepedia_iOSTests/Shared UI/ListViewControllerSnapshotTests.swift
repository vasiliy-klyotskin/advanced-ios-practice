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
}
