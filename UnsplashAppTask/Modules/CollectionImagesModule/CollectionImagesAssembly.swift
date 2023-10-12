//
//  CollectionImagesAssembly.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit

final class CollectionImagesAssembly {
    static func assembleCollectionImagesModule() -> UIViewController {
        let presenter = CollectionImagesPresenter()
        let view = CollectionImagesViewController(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
