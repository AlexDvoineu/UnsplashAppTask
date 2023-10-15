//
//  ImageDetailsPresenterTests.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import Foundation
import XCTest

final class ImageDetailsPresenterTests: XCTestCase {
    private var storage: FavouritesStorageTestDouble!
    private var networkManager: APIManagerProtocolTestDouble!
    private var imageDownloader: ImageDownloaderProtocolTestDouble!
    private var imageDetailsInput: ImageDetailsViewInputTestDouble!

    override func setUp() {
        super.setUp()
        storage = .init()
        networkManager = .init()
        imageDownloader = .init()
        imageDetailsInput = .init()
    }

    func test_viewDidLoad_imageLocalNotLoaded_imageNotFavourite_imageRemoteDataNotLoaded() {
        // GIVEN
        let expectation = XCTestExpectation()
        let image = FakeImageDetails(
            id: "id",
            title: "title",
            description: "description",
            imageUrl: URL(string: "https://some-url.com")!,
            authorsName: "authorsName"
        )
        let sut = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: networkManager,
            imageDownloader: imageDownloader
        )
        sut.view = imageDetailsInput
        imageDownloader.downloadImageWithUrlCompletionReturnValue = nil
        storage.imageExistsIdReturnValue = false
        networkManager.getImagesByIDForIDCompletedReturnValue = .failure(.invalidRequest)
        imageDetailsInput.showErrorCallback = {
            expectation.fulfill()
        }

        // WHEN
        sut.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(imageDownloader.downloadImageWithUrlCompletionIsCalled)
        XCTAssertFalse(imageDetailsInput.setImageImageIsCalled)
        XCTAssertTrue(imageDetailsInput.setFavouriteStateIsCalled)
        XCTAssertFalse(imageDetailsInput.setFavouriteStateIsFavouriteValue)
        XCTAssertTrue(imageDetailsInput.configureImageLocationDownloadsIsCalled)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsImageValue?.id, image.id)
        XCTAssertTrue(networkManager.getImagesByIDForIDCompletedIsCalled)
        XCTAssertEqual(networkManager.getImagesByIDForIDCompletedIDValue, image.id)
        XCTAssertTrue(imageDetailsInput.showErrorIsCalled)
    }

    func test_viewDidLoad_imageLocalNotLoaded_imageFavourite_imageRemoteDataNotLoaded() {
        // GIVEN
        let expectation = XCTestExpectation()
        let image = FakeImageDetails(
            id: "id",
            title: "title",
            description: "description",
            imageUrl: URL(string: "https://some-url.com")!,
            authorsName: "authorsName"
        )
        let sut = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: networkManager,
            imageDownloader: imageDownloader
        )
        sut.view = imageDetailsInput
        imageDownloader.downloadImageWithUrlCompletionReturnValue = nil
        storage.imageExistsIdReturnValue = true
        networkManager.getImagesByIDForIDCompletedReturnValue = .failure(.invalidRequest)
        imageDetailsInput.showErrorCallback = {
            expectation.fulfill()
        }

        // WHEN
        sut.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(imageDownloader.downloadImageWithUrlCompletionIsCalled)
        XCTAssertFalse(imageDetailsInput.setImageImageIsCalled)
        XCTAssertTrue(imageDetailsInput.setFavouriteStateIsCalled)
        XCTAssertTrue(imageDetailsInput.setFavouriteStateIsFavouriteValue)
        XCTAssertTrue(imageDetailsInput.configureImageLocationDownloadsIsCalled)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsImageValue?.id, image.id)
        XCTAssertTrue(networkManager.getImagesByIDForIDCompletedIsCalled)
        XCTAssertEqual(networkManager.getImagesByIDForIDCompletedIDValue, image.id)
        XCTAssertTrue(imageDetailsInput.showErrorIsCalled)
    }

    func test_viewDidLoad_imageLocalNotLoaded_imageNotFavourite_imageRemoteDataLoaded() {
        // GIVEN
        let expectation = XCTestExpectation()
        let image = FakeImageDetails(
            id: "id",
            title: "title",
            description: "description",
            imageUrl: URL(string: "https://some-url.com")!,
            authorsName: "authorsName"
        )
        let remoteImageResult = ImageResult(
            location: LocationData(name: "location"),
            downloads: .zero,
            topics: [],
            description: nil
        )
        let sut = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: networkManager,
            imageDownloader: imageDownloader
        )
        sut.view = imageDetailsInput
        imageDownloader.downloadImageWithUrlCompletionReturnValue = nil
        storage.imageExistsIdReturnValue = false
        networkManager.getImagesByIDForIDCompletedReturnValue = .success(remoteImageResult)
        imageDetailsInput.configureImageLocationDownloadsCallbackCondition = { [weak imageDetailsInput] in
            if let callsCount = imageDetailsInput?.configureImageLocationDownloadsCallsCount {
                return callsCount > 1
            }
            return true
        }
        imageDetailsInput.configureImageLocationDownloadsCallback = {
            expectation.fulfill()
        }

        // WHEN
        sut.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(imageDownloader.downloadImageWithUrlCompletionIsCalled)
        XCTAssertFalse(imageDetailsInput.setImageImageIsCalled)
        XCTAssertTrue(imageDetailsInput.setFavouriteStateIsCalled)
        XCTAssertFalse(imageDetailsInput.setFavouriteStateIsFavouriteValue)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsImageValue?.id, image.id)
        XCTAssertTrue(networkManager.getImagesByIDForIDCompletedIsCalled)
        XCTAssertEqual(networkManager.getImagesByIDForIDCompletedIDValue, image.id)
        XCTAssertTrue(imageDetailsInput.configureImageLocationDownloadsIsCalled)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsLocationValue, remoteImageResult.location.name)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsDownloadsValue, remoteImageResult.downloads)
        XCTAssertFalse(imageDetailsInput.showErrorIsCalled)
    }

    func test_viewDidLoad_imageLocalLoaded_imageNotFavourite_imageRemoteDataLoaded() {
        // GIVEN
        let expectation = XCTestExpectation()
        let image = FakeImageDetails(
            id: "id",
            title: "title",
            description: "description",
            imageUrl: URL(string: "https://some-url.com")!,
            authorsName: "authorsName"
        )
        let remoteImageResult = ImageResult(
            location: LocationData(name: "location"),
            downloads: .zero,
            topics: [],
            description: nil
        )
        let sut = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: networkManager,
            imageDownloader: imageDownloader
        )
        sut.view = imageDetailsInput
        imageDownloader.downloadImageWithUrlCompletionReturnValue = UIImage()
        storage.imageExistsIdReturnValue = false
        networkManager.getImagesByIDForIDCompletedReturnValue = .success(remoteImageResult)
        imageDetailsInput.configureImageLocationDownloadsCallbackCondition = { [weak imageDetailsInput] in
            if let callsCount = imageDetailsInput?.configureImageLocationDownloadsCallsCount {
                return callsCount > 1
            }
            return true
        }
        imageDetailsInput.configureImageLocationDownloadsCallback = {
            expectation.fulfill()
        }

        // WHEN
        sut.viewDidLoad()
        wait(for: [expectation], timeout: 1.0)

        // THEN
        XCTAssertTrue(imageDownloader.downloadImageWithUrlCompletionIsCalled)
        XCTAssertTrue(imageDetailsInput.setImageImageIsCalled)
        XCTAssertTrue(imageDetailsInput.setFavouriteStateIsCalled)
        XCTAssertFalse(imageDetailsInput.setFavouriteStateIsFavouriteValue)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsImageValue?.id, image.id)
        XCTAssertTrue(networkManager.getImagesByIDForIDCompletedIsCalled)
        XCTAssertEqual(networkManager.getImagesByIDForIDCompletedIDValue, image.id)
        XCTAssertTrue(imageDetailsInput.configureImageLocationDownloadsIsCalled)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsLocationValue, remoteImageResult.location.name)
        XCTAssertEqual(imageDetailsInput.configureImageLocationDownloadsDownloadsValue, remoteImageResult.downloads)
        XCTAssertFalse(imageDetailsInput.showErrorIsCalled)
    }

    func test_favouriteButtonTapped_isFavourite_true_notConfirmed() {
        // GIVEN
        let image = FakeImageDetails(
            id: "id",
            title: "title",
            description: "description",
            imageUrl: URL(string: "https://some-url.com")!,
            authorsName: "authorsName"
        )
        let sut = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: networkManager,
            imageDownloader: imageDownloader
        )
        sut.view = imageDetailsInput
        storage.imageExistsIdReturnValue = true

        // WHEN
        sut.favouriteButtonTapped()

        // THEN
        XCTAssertTrue(storage.imageExistsIdIsCalled)
        XCTAssertTrue(imageDetailsInput.showDeleteConfirmationAlertIsCalled)
        XCTAssertFalse(storage.removeImageIdIsCalled)
        XCTAssertFalse(imageDetailsInput.setFavouriteStateIsCalled)
    }

    func test_favouriteButtonTapped_isFavourite_true_confirmed() {
        // GIVEN
        let image = FakeImageDetails(
            id: "id",
            title: "title",
            description: "description",
            imageUrl: URL(string: "https://some-url.com")!,
            authorsName: "authorsName"
        )
        let sut = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: networkManager,
            imageDownloader: imageDownloader
        )
        sut.view = imageDetailsInput
        storage.imageExistsIdReturnValue = true
        imageDetailsInput.showDeleteConfirmationAlertCompletionReturnValue = true

        // WHEN
        sut.favouriteButtonTapped()

        // THEN
        XCTAssertTrue(storage.imageExistsIdIsCalled)
        XCTAssertTrue(imageDetailsInput.showDeleteConfirmationAlertIsCalled)
        XCTAssertTrue(storage.removeImageIdIsCalled)
        XCTAssertEqual(storage.removeImageIdId, image.id)
        XCTAssertTrue(imageDetailsInput.setFavouriteStateIsCalled)
        XCTAssertFalse(imageDetailsInput.setFavouriteStateIsFavouriteValue)
    }

    func test_favouriteButtonTapped_isFavourite_false() {
        // GIVEN
        let image = FakeImageDetails(
            id: "id",
            title: "title",
            description: "description",
            imageUrl: URL(string: "https://some-url.com")!,
            authorsName: "authorsName"
        )
        let sut = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: networkManager,
            imageDownloader: imageDownloader
        )
        sut.view = imageDetailsInput
        storage.imageExistsIdReturnValue = false

        // WHEN
        sut.favouriteButtonTapped()

        // THEN
        XCTAssertTrue(storage.imageExistsIdIsCalled)
        XCTAssertTrue(imageDetailsInput.setFavouriteStateIsFavouriteValue)
        XCTAssertTrue(imageDetailsInput.showSuccesSavedAlertIsCalled)
        XCTAssertTrue(storage.addImageImageIsCalled)
    }
}
