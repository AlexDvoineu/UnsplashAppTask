//
//  CollectionImagesPresenterTests.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import Foundation
import XCTest

final class CollectionImagesPresenterTests: XCTestCase {
    private var apiManager: APIManagerProtocolTestDouble!
    private var collectionImagesInput: CollectionImagesInputTestDouble!

    override func setUp() {
        super.setUp()
        apiManager = .init()
        collectionImagesInput = .init()
    }

    func test_viewDidLoad_imagesRemoteDataNotLoaded() {
        // GIVEN
        let expectation = XCTestExpectation()
        let sut = CollectionImagesPresenter(apiManager: apiManager)
        sut.view = collectionImagesInput
        sut.page = 1
        apiManager.getRandomImagesPageCompletedReturnValue = .failure(.invalidRequest)
        collectionImagesInput.showErrorCallback = {
            expectation.fulfill()
        }

        // WHEN
        sut.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(collectionImagesInput.showLoadingViewIsCalled)
        XCTAssertTrue(apiManager.getRandomImagesPageCompletedIsCalled)
        XCTAssertEqual(apiManager.getRandomImagesPageCompletedPageValue, 1)
        XCTAssertTrue(collectionImagesInput.showErrorIsCalled)
    }

    func test_viewDidLoad_imagesRemoteDataLoaded() {
        // GIVEN
        let expectation = XCTestExpectation()
        let sut = CollectionImagesPresenter(apiManager: apiManager)
        sut.view = collectionImagesInput
        sut.page = 1
        apiManager.getRandomImagesPageCompletedReturnValue = .success([])
        collectionImagesInput.reloadDataCallback = {
            expectation.fulfill()
        }

        // WHEN
        sut.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(collectionImagesInput.showLoadingViewIsCalled)
        XCTAssertTrue(apiManager.getRandomImagesPageCompletedIsCalled)
        XCTAssertEqual(apiManager.getRandomImagesPageCompletedPageValue, 1)
        XCTAssertEqual(sut.numberOfItems, .zero)
        XCTAssertTrue(collectionImagesInput.reloadDataIsCalled)
        XCTAssertFalse(collectionImagesInput.showErrorIsCalled)
    }

    func test_cancelSearching_defaultState() {
        // GIVEN
        let sut = CollectionImagesPresenter(apiManager: apiManager)
        sut.view = collectionImagesInput

        // WHEN
        sut.cancelSearching()

        // THEN
        XCTAssertTrue(collectionImagesInput.reloadDataIsCalled)
        XCTAssertEqual(sut.numberOfItems, .zero)
    }

    func test_searchImages_defaultState() {
        // GIVEN
        let sut = CollectionImagesPresenter(apiManager: apiManager)
        sut.view = collectionImagesInput

        // WHEN
        sut.searchImages(searchText: "")

        // THEN
        XCTAssertTrue(collectionImagesInput.reloadDataIsCalled)
        XCTAssertEqual(sut.numberOfItems, .zero)
    }

    func test_searchImages_imagesRemoteDataNotLoaded() {
        // GIVEN
        let expectation = XCTestExpectation()
        let sut = CollectionImagesPresenter(apiManager: apiManager)
        sut.view = collectionImagesInput
        let searchText = "request"
        collectionImagesInput.reloadDataCallback = {
            expectation.fulfill()
        }
        apiManager.getImagesByRequestForSearchRequestPageReturnValue = .failure(.invalidRequest)

        // WHEN
        sut.searchImages(searchText: searchText)
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(collectionImagesInput.showLoadingViewIsCalled)
        XCTAssertTrue(apiManager.getImagesByRequestForSearchRequestPageCompletedIsCalled)
        XCTAssertEqual(apiManager.getImagesByRequestForSearchRequestPageSearchRequest, searchText)
        XCTAssertTrue(collectionImagesInput.showErrorIsCalled)
        XCTAssertTrue(collectionImagesInput.reloadDataIsCalled)
    }

    func test_searchImages_imagesRemoteDataLoaded_lessThanLimit() {
        // GIVEN
        let expectation = XCTestExpectation()
        let sut = CollectionImagesPresenter(apiManager: apiManager)
        sut.view = collectionImagesInput
        sut.page = 1
        let searchText = "request"
        collectionImagesInput.reloadDataCallback = { [weak sut] in
            sut?.loadNextPageIfNeeded()
            expectation.fulfill()
        }
        let results: [ImagesResult] = [
            .init(
                id: "id",
                likes: 1,
                updatedAt: .init(),
                urls: .init(thumb: "thumb", small: "small"),
                user: .init(name: "name")
            )
        ]
        apiManager.getImagesByRequestForSearchRequestPageReturnValue = .success(.init(results: results))

        // WHEN
        sut.searchImages(searchText: searchText)
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(collectionImagesInput.showLoadingViewIsCalled)
        XCTAssertTrue(apiManager.getImagesByRequestForSearchRequestPageCompletedIsCalled)
        XCTAssertEqual(apiManager.getImagesByRequestForSearchRequestPageSearchRequest, searchText)
        XCTAssertFalse(collectionImagesInput.showErrorIsCalled)
        XCTAssertTrue(collectionImagesInput.reloadDataIsCalled)
        XCTAssertEqual(sut.numberOfItems, results.count)
        XCTAssertEqual(sut.page, 1)
    }

    func test_searchImages_imagesRemoteDataLoaded_moreThanLimit() {
        // GIVEN
        let expectation = XCTestExpectation()
        let sut = CollectionImagesPresenter(apiManager: apiManager)
        sut.view = collectionImagesInput
        sut.page = 1
        let searchText = "request"
        collectionImagesInput.reloadDataCallback = { [weak sut] in
            sut?.loadNextPageIfNeeded()
            expectation.fulfill()
        }
        let results: [ImagesResult] = Array(
            repeating: .init(
                id: "id",
                likes: 1,
                updatedAt: .init(),
                urls: .init(thumb: "thumb", small: "small"),
                user: .init(name: "name")
            ),
            count: 31
        )
        apiManager.getImagesByRequestForSearchRequestPageReturnValue = .success(.init(results: results))

        // WHEN
        sut.searchImages(searchText: searchText)
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(collectionImagesInput.showLoadingViewIsCalled)
        XCTAssertTrue(apiManager.getImagesByRequestForSearchRequestPageCompletedIsCalled)
        XCTAssertEqual(apiManager.getImagesByRequestForSearchRequestPageSearchRequest, searchText)
        XCTAssertFalse(collectionImagesInput.showErrorIsCalled)
        XCTAssertTrue(collectionImagesInput.reloadDataIsCalled)
        XCTAssertEqual(sut.numberOfItems, results.count)
        XCTAssertEqual(sut.page, 2)
    }
}
