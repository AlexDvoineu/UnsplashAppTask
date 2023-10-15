//
//  FavouriteImagesPresenter.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

final class FavouriteImagesPresenter {
    weak var view: FavouriteImagesInput?
    private var storage: FavouritesStorage
    lazy var favoritesArray: [ImageDetails] = []
    
    init(storage: FavouritesStorage) {
        self.storage = storage
    }
}

extension FavouriteImagesPresenter: FavouriteImagesOutput {
    func viewDidAppear() {
        updateData()
    }
    
    func viewWillAppear() {
        updateData()
    }

    func updateData() {
        favoritesArray = storage.items
        view?.reloadData()
    }
}
