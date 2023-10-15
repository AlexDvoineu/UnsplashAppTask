//
//  FavouriteImagesAssembly.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

class FavouriteImagesAssembly {
    static func assembleFavouriteImagesModule() -> UIViewController {
        let storage = PersistenceManager.sharedRealm
        let presenter = FavouriteImagesPresenter(storage: storage)
        let view = FavouriteImagesViewController(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
