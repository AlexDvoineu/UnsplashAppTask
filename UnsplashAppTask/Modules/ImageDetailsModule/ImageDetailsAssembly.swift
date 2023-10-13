//
//  ImageDetailsAssembly.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

final class ImageDetailsAssembly {
    static func assembleImageDetailsModule(
        image: Image,
        fromFavouritePhoto: Bool,
        delegate: ImageDetailsViewControllerDelegate
    ) -> UIViewController {
        let presenter = ImageDetailsPresenter()
        let view = ImageDetailsViewController(presenter: presenter)
        view.presenter = presenter
        view.delegate = delegate
        presenter.view = view
        presenter.image = image
        presenter.fromFavouritePhoto = fromFavouritePhoto
        return view
    }
}
