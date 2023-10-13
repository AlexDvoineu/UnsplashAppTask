//
//  ImageDetailsPresenterProtocol.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

protocol ImageDetailsPresenterProtocol {
    func viewDidLoad()
    func setupDate(image: Image) -> String
    func checkFavouriteButton(isFavourite: Bool)
    func checkFavourites()
}
