//
//  RandomRequestModel.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

struct RandomImagesResult: Codable, Hashable {
    let id: String
    let likes: Int
    let urls: URLS
    let user: UnsplashUsers
    
}

extension RandomImagesResult: ImageDetails {
    var title: String { "" }
    var description: String { "" }
    var imageUrl: URL { URL(string: urls.small) ?? URL(string: urls.thumb)! }
    var authorsName: String { user.name }
}

struct UnsplashUsers: Codable, Hashable {
    let name: String
}

struct APIResponse: Codable, Hashable {
    let results: [ImagesResult]
}

struct ImagesResult: Codable {
    let uuid = UUID()
    let id: String
    let likes: Int
    let updatedAt: Date
    let urls: URLS
    let user: UnsplashUsers

    private enum CodingKeys : String, CodingKey {
        case id
        case likes
        case user
        case updatedAt
        case urls
    }
}

extension ImagesResult: ImageDetails {
    var title: String { "" }
    var description: String { "" }
    var imageUrl: URL { URL(string: urls.small) ?? URL(string: urls.thumb)! }
    var authorsName: String { user.name }
}

extension ImagesResult: Hashable{
    static func ==(lhs: ImagesResult, rhs: ImagesResult) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct URLS: Codable, Hashable{
    let thumb: String
    let small: String
}
