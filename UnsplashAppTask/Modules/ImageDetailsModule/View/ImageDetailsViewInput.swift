//
//  ImageDetailsViewInput.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

protocol ImageDetailsViewInput: AnyObject {
    func configure(image: Image)
    func setImage(image: UIImage)
    func setFavourite(isFavourite: Bool)
    func passImageData(image: Image)
    func deleteImageData(image: Image)
}
