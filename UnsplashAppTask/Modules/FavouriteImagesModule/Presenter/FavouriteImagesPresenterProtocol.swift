//
//  FavouriteImagesPresenterProtocol.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

protocol FavouriteImagesPresenterProtocol {
    func viewWillAppear()
    func passImageData(image: Image)
    func deleteImageData(image: Image)
}
