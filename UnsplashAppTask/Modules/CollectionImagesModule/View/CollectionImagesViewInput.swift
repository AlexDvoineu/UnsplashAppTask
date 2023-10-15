//
//  CollectionImagesViewInput.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import UIKit

protocol CollectionImagesInput: AnyObject {
    func dismissLoadingView()
    func reloadData()

    func showLoadingView()

    func showError(_ error: ErrorMessages)
}
