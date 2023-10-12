//
//  Image.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import Foundation

struct Image: Codable, Equatable {
    let id: String
    let authorName: String
    let createDate: String
    let downloads: Int
    let location: String
    let smallPhoto: String
    let fullPhoto: String

    init?(imageData: ImageData) {
        id = imageData.id ?? ""
        authorName = imageData.user?.name ?? ""
        createDate = imageData.createDate ?? ""
        downloads = imageData.downloads ?? 1
        location = imageData.location?.name ?? ""
        smallPhoto = imageData.urls?.thumb ?? ""
        fullPhoto = imageData.urls?.full ?? ""
    }

    init?(searchData: Results) {
        id = searchData.id ?? ""
        authorName = searchData.user?.name ?? ""
        createDate = searchData.createDate ?? ""
        smallPhoto = searchData.urls?.thumb ?? ""
        fullPhoto = searchData.urls?.full ?? ""
        downloads = 0
        location = ""
    }

    init(
        authorName: String,
        createDate: String,
        downloads: Int,
        location: String,
        smallPhoto: String,
        fullPhoto: String,
        id: String
    ) {
        self.id = id
        self.authorName = authorName
        self.createDate = createDate
        self.downloads = downloads
        self.location = location
        self.smallPhoto = smallPhoto
        self.fullPhoto = fullPhoto
    }
}
