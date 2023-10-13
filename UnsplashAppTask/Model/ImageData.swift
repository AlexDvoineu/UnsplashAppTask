//
//  ImageData.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import Foundation

struct ImageData: Codable {
    let id: String?
    let createDate: String?
    let urls: Urls?
    let user: User?
    let location: Location?
    let downloads: Int?
    let title: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case downloads
        case location
        case createDate = "created_at"
        case urls
        case title = "slug"
        case description = "alt_description"
    }
}

struct SearchData: Codable {
    let results: [UnsplashResult]?
}

struct Urls: Codable {
    let full: String?
    let thumb: String?
}

struct User: Codable {
    let name: String?
}

struct Location: Codable {
    let name: String?
}

struct UnsplashResult: Codable {
    let id: String?
    let createDate: String?
    let urls: Urls?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case createDate = "created_at"
        case urls
    }
}
