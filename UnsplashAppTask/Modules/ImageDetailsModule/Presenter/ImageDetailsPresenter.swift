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
    private var isFavourit: Bool {
        storage.imageExist(id: image.id)
    }
    
    init(image: ImageDetails, storage: FavouritesStorage) {
        self.storage = storage
        self.image = image
    }

}

extension ImageDetailsPresenter: ImageDetailsPresenterOutput {
    
    func viewDidLoad() {
        downloadAndSetupImage()
        view?.setFavouriteState(isFavourite: isFavourit)
        view?.configure(image: image)
    }
    
    func favoriteButtonTapped() {
        let imageId = image.id
        guard !isFavourit else {
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
        SDWebImageDownloader.shared.downloadImage(with: image.imageUrl) { [weak self] (image, data, error, finished) in
            guard let self, let image else { return }
            self.view?.setImage(image: image)
        }
    }
}
