//
//  ListViewControllerSnapshotTests.swift
//  Pokepedia_iOSTests
//
//  Created by Василий Клецкин on 7/27/23.
//

import XCTest
import Combine
import Pokepedia_iOS
import Pokepedia_iOS_App
@testable import Pokepedia

final class ListControllerSnapshotTests: XCTestCase {
    func test_initialState() {
        let sut = makeSut()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LIST_EMPTY_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LIST_EMPTY_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "LIST_EMPTY_light_extraExtraExtraLarge")
    }
    
    func test_listIsLoadingSnapshot() {
        let sut = makeSut()
        
        sut.display(loadingViewModel: .init(isLoading: true))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LIST_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LIST_LOADING_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "LIST_LOADING_light_extraExtraExtraLarge")
    }
    
    func test_listLoadedWithErrorSnapshot() {
        let sut = makeSut()
        
        sut.display(errorViewModel: .init(errorMessage: "Some multiline \nerror message text"))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LIST_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LIST_ERROR_dark")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light, contentSize: .extraExtraExtraLarge)), named: "LIST_ERROR_light_extraExtraExtraLarge")
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
