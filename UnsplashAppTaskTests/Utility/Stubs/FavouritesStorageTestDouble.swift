//
//  FavouritesStorageTestDouble.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import Foundation

final class FavouritesStorageTestDouble: FavouritesStorage {
    var items: [ImageDetails] = []

    var imageExistsIdCallsCount: Int = .zero
    var imageExistsIdIsCalled: Bool {
        imageExistsIdCallsCount > .zero
    }
    var imageExistsIdId: String?
    var imageExistsIdReturnValue: Bool = false

    func imageExist(id: String) -> Bool {
        imageExistsIdCallsCount += 1
        imageExistsIdId = id
        return imageExistsIdReturnValue
    }

    var addImageImageCallsCount: Int = .zero
    var addImageImageIsCalled: Bool {
        addImageImageCallsCount > .zero
    }
    var addImageImage: ImageDetails?

    func addImage(_ image: ImageDetails) {
        addImageImageCallsCount += 1
        addImageImage = image
    }

    var removeImageIdCallsCount: Int = .zero
    var removeImageIdIsCalled: Bool {
        removeImageIdCallsCount > .zero
    }
    var removeImageIdId: String?

    func removeImage(id: String) {
        removeImageIdCallsCount += 1
        removeImageIdId = id
    }
}
