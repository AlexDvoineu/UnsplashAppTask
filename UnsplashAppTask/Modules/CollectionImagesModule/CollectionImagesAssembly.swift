//
//  CollectionImagesAssembly.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import UIKit

final class CollectionImagesAssembly {
    static func assembleCollectionImagesModule() -> UIViewController {
        let presenter = CollectionImagesPresenter(
            apiManager: APIManager.shared
        )
        let view = CollectionImagesViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
