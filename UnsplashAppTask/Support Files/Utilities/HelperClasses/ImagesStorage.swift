//
//  ImagesStorage.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

class ImagesStorage {
    static let shared = ImagesStorage()

    private let storage = UserDefaults.standard
    private let storageKey: String = "images"

    func loadNotes() -> [Image] {
        var resultImages: [Image] = []
        if let imagesFromStorage = storage.data(forKey: storageKey) {
            do {
                let image = try JSONDecoder().decode([Image].self, from: imagesFromStorage)
                resultImages.append(contentsOf: image)
            } catch {
                print(error)
            }
        }
        return resultImages
    }

    func saveNotes(_ images: [Image]) {
        do {
            let imageData = try JSONEncoder().encode(images)
            storage.set(imageData, forKey: storageKey)
        } catch {
            print(error)
        }
    }

    func appendPhoto(_ images: [Image]) {
        var imagesFromStorage = loadNotes()
        imagesFromStorage.append(contentsOf: images)
        saveNotes(imagesFromStorage)
    }
}
