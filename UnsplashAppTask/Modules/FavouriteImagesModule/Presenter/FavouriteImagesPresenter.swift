//
//  FavouriteImagesPresenter.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

final class FavouriteImagesPresenter: FavouriteImagesPresenterProtocol {
    weak var view: FavouriteImagesViewInput?

    var imageData: [Image] = []

    func viewWillAppear() {
        imageData = ImagesStorage.shared.loadNotes()
        checkFavouriteImages()
        view?.reloadData()
    }

    func passImageData(image: Image) {
        self.imageData.removeAll(where: { $0.id == image.id })
        imageData.append(image)
        ImagesStorage.shared.saveNotes(imageData)
        view?.reloadData()
    }

    func deleteImageData(image: Image) {
        self.imageData.removeAll(where: { $0.id == image.id })
        ImagesStorage.shared.saveNotes(imageData)
        view?.reloadData()
    }

    private func checkFavouriteImages() {
        if imageData.isEmpty {
            view?.showAlert(isEmpty: true)
        } else {
            view?.showAlert(isEmpty: false)
        }
    }
}
