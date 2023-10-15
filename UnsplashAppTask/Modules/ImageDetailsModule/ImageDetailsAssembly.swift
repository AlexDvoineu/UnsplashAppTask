//
//  ImageDetailsAssembly.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

#warning("поставить вместо ImageDetails id")
final class ImageDetailsAssembly {
    static func assembleImageDetailsModule(
        image: ImageDetails,
        delegate: ReloadTableProtocol?
    ) -> ImageDetailsViewController {
        let storage = PersistenceManager.sharedRealm

        let presenter = ImageDetailsPresenter(
            image: image,
            storage: storage,
            apiManager: APIManager.shared,
            imageDownloader: ImageDownloader()
        )
        let view = ImageDetailsViewController(presenter: presenter)

        view.reloadDelegate = delegate
        presenter.view = view

        return view
    }
}
