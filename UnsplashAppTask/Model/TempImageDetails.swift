//
//  TempImageDetails.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

import Foundation

struct TempImageDetails: ImageDetails {
    var id: String
    var title: String
    var description: String
    var imageUrl: URL
    var authorsName: String
    
    init(id: String, title: String, description: String, imageUrl: URL, authorsName: String) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.authorsName = authorsName
    }
    
    init(image: ImageDetails) {
        id = image.id
        title = image.title
        description = image.description
        imageUrl = image.imageUrl
        authorsName = image.authorsName
    }
}

