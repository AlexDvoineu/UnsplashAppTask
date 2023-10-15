//
//  FavouritesStorage.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

protocol FavouritesStorage {
    var items: [ImageDetails] { get }

    func imageExist(id: String) -> Bool
    func addImage(_ image: ImageDetails)
    func removeImage(id: String)
}
