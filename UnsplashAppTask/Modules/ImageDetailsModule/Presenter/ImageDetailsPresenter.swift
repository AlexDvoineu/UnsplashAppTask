//
//  ImageDetailsPresenter.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation
import SDWebImage

final class ImageDetailsPresenter {
    weak var view: ImageDetailsViewInput?

    private var image: ImageDetails
    private let storage: FavouritesStorage
    private let apiManager: APIManagerProtocol
    private let imageDownloader: ImageDownloaderProtocol

    private var isFavourite: Bool {
        storage.imageExist(id: image.id)
    }

    init(
        image: ImageDetails,
        storage: FavouritesStorage,
        apiManager: APIManagerProtocol,
        imageDownloader: ImageDownloaderProtocol
    ) {
        self.storage = storage
        self.image = image
        self.apiManager = apiManager
        self.imageDownloader = imageDownloader
    }
}

extension ImageDetailsPresenter: ImageDetailsPresenterOutput {
    func viewDidLoad() {
        downloadAndSetupImage()
        view?.setFavouriteState(isFavourite: isFavourite)
        view?.configure(image: image, location: nil, downloads: 0)
        getImageData()
    }

    func favouriteButtonTapped() {
        let imageId = image.id
        guard !isFavourite else {
            view?.showDeleteConfirmationAlert(completion: { [weak self] confirm in
                guard let self, confirm else { return }
                self.storage.removeImage(id: imageId)
                self.view?.setFavouriteState(isFavourite: false)
            })
            return
        }

        view?.setFavouriteState(isFavourite: true)
        view?.showSuccesSavedAlert()
        storage.addImage(image)
    }
}

private extension ImageDetailsPresenter {
    func downloadAndSetupImage() {
        imageDownloader.downloadImage(with: image.imageUrl) { [weak self] (image) in
            guard let self, let image else { return }
            self.view?.setImage(image: image)
        }
    }

    private func getImageData() {
        apiManager.getImagesByID(for: image.id) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                    case .success(let data):
                        self.view?.configure(image: self.image, location: data.location.name, downloads: data.downloads ?? 0)

                    case .failure(let error):
                        self.view?.showError(error)
                }
            }
        }
    }
}
