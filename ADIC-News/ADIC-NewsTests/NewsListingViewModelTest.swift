//
//  NewsListingViewModelTest.swift
//  ADIC-NewsTests
//
//  Created by Edwin Wilson on 02/09/2021.
//

import XCTest
@testable import ADIC_News

class NewsListingViewModelTest: XCTestCase, NewsListingViewModelDelegate {

    enum TestingError: Error {

        case downLoadFailed
    }

    var newsFetchExp: XCTestExpectation?

    let model = NewsListingViewModel()

    override func setUpWithError() throws {

        model.delegate = self
        newsFetchExp = expectation(description: "fetchNews")
        model.fetchNews()
        waitForExpectations(timeout: 60.0, handler: nil)
        if model.state.news?.isEmpty ?? true {
            throw TestingError.downLoadFailed
        }
    }

    func testPerformanceExample() throws {

        self.measure {
            newsFetchExp = expectation(description: "fetchNews")
            model.fetchNews()
            waitForExpectations(timeout: 60.0, handler: nil)
        }
    }

    func testNewsFetch() {

        let model = NewsListingViewModel()
        model.delegate = self
        newsFetchExp = expectation(description: "fetchNews")
        model.fetchNews()
        waitForExpectations(timeout: 60.0, handler: nil)
        guard let news = model.state.news else {
            XCTFail("news download failed")
            return
        }

        XCTAssertFalse(news.isEmpty, "No items inside news")
    }

    func testSearchWithOutFilter() {

        guard let news = model.state.news else {
            XCTFail("news download failed")
            return
        }
        let searchKey = news.first?.title
        model.search(for: searchKey)
        XCTAssertTrue(model.state.filteredItems?.count == 1)
        model.search(for: nil)
        XCTAssertNil(model.state.filteredItems)
    }

    func testFilter() {

        guard let news = model.state.news,
              let filterItem = news.first?.type else {
            XCTFail("news download failed")
            return
        }

        model.applyFilter(type: .type, value: filterItem, didEnabled: true)
        XCTAssertTrue(model.state.applyedFilters[.type]?.count == 1)
        XCTAssertFalse(model.state.filteredItems?.isEmpty ?? true)
        model.applyFilter(type: .type, value: filterItem, didEnabled: false)
        XCTAssertTrue(model.state.applyedFilters[.type]?.isEmpty ?? false)
        XCTAssertNil(model.state.filteredItems)
    }

    func didFetchNews(isSuccessFull: Bool) {

        newsFetchExp?.fulfill()
    }

    func didUpdateResults() {

    }

}
