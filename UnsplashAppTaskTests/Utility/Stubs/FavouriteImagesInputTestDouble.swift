//
//  FavouriteImagesInputTestDouble.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import Foundation

final class FavouriteImagesInputTestDouble: FavouriteImagesInput {
    var reloadDataCallsCount: Int = .zero
    var reloadDataIsCalled: Bool {
        reloadDataCallsCount > .zero
    }

    func reloadData() {
        reloadDataCallsCount += 1
    }
}
