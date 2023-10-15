//
//  ImageDetailsViewInputTestDouble.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import UIKit

final class ImageDetailsViewInputTestDouble: ImageDetailsViewInput {
    var configureImageLocationDownloadsCallsCount: Int = .zero
    var configureImageLocationDownloadsIsCalled: Bool {
        configureImageLocationDownloadsCallsCount > .zero
    }
    var configureImageLocationDownloadsImageValue: ImageDetails?
    var configureImageLocationDownloadsLocationValue: String?
    var configureImageLocationDownloadsDownloadsValue: Int?
    var configureImageLocationDownloadsCallback: (() -> Void)?
    var configureImageLocationDownloadsCallbackCondition: (() -> Bool) = { true }

    func configure(image: UnsplashAppTask.ImageDetails, location: String?, downloads: Int) {
        configureImageLocationDownloadsCallsCount += 1
        configureImageLocationDownloadsImageValue = image
        configureImageLocationDownloadsLocationValue = location
        configureImageLocationDownloadsDownloadsValue = downloads
        if configureImageLocationDownloadsCallbackCondition() {
            configureImageLocationDownloadsCallback?()
        }
    }

    var setImageImageCallsCount: Int = .zero
    var setImageImageIsCalled: Bool {
        setImageImageCallsCount > .zero
    }

    func setImage(image: UIImage) {
        setImageImageCallsCount += 1
    }

    var setFavouriteStateCallsCount: Int = .zero
    var setFavouriteStateIsCalled: Bool {
        setFavouriteStateCallsCount > .zero
    }
    var setFavouriteStateIsFavouriteValue: Bool = false

    func setFavouriteState(isFavourite: Bool) {
        setFavouriteStateCallsCount += 1
        setFavouriteStateIsFavouriteValue = isFavourite
    }

    var showSuccesSavedAlertCallsCount: Int = .zero
    var showSuccesSavedAlertIsCalled: Bool {
        showSuccesSavedAlertCallsCount > .zero
    }

    func showSuccesSavedAlert() {
        showSuccesSavedAlertCallsCount += 1
    }

    var showDeleteConfirmationAlertCallsCount: Int = .zero
    var showDeleteConfirmationAlertIsCalled: Bool {
        showDeleteConfirmationAlertCallsCount > .zero
    }
    var showDeleteConfirmationAlertCompletionReturnValue: Bool = false

    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        showDeleteConfirmationAlertCallsCount += 1
        completion(showDeleteConfirmationAlertCompletionReturnValue)
    }

    var showErrorCallsCount: Int = .zero
    var showErrorIsCalled: Bool {
        showErrorCallsCount > .zero
    }
    var showErrorCallback: (() -> Void)?

    func showError(_ error: UnsplashAppTask.ErrorMessages) {
        showErrorCallsCount += 1
        showErrorCallback?()
    }
}
