//
//  ImageDetailsViewInput.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

protocol ImageDetailsViewInput: AnyObject {
    func configure(image: ImageDetails, location: String?, downloads: Int)
    func setImage(image: UIImage)
    func setFavouriteState(isFavourite: Bool)
    func showSuccesSavedAlert()
    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void)
    func showError(_ error: ErrorMessages)
}
