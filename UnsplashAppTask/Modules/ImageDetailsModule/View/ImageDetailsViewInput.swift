//
//  ImageDetailsViewInput.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

protocol ImageDetailsViewInput: AnyObject {
    func configure(image: ImageDetails)
    func setImage(image: UIImage)
    func setFavouriteState(isFavourite: Bool)
//    func passImageData(image: Image)
//    func deleteImageData(image: Image)
    
    func showSuccesSavedAlert()
    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void)
}
