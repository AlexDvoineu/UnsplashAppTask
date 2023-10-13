//
//  FavouriteImagesViewInput.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

protocol FavouriteImagesViewInput: AnyObject {
    func reloadData()
    func showAlert(isEmpty: Bool)
}
