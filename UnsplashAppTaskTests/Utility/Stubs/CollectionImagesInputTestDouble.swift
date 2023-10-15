//
//  CollectionImagesInputTestDouble.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import Foundation

final class CollectionImagesInputTestDouble: CollectionImagesInput {
    func dismissLoadingView() {

    }

    var reloadDataCallsCount: Int = .zero
    var reloadDataIsCalled: Bool {
        reloadDataCallsCount > .zero
    }
    var reloadDataCallback: (() -> Void)?

    func reloadData() {
        reloadDataCallsCount += 1
        reloadDataCallback?()
    }

    var showLoadingViewCallsCount: Int = .zero
    var showLoadingViewIsCalled: Bool {
        showLoadingViewCallsCount > .zero
    }

    func showLoadingView() {
        showLoadingViewCallsCount += 1
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
