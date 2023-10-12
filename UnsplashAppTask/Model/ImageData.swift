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

    enum CodingKeys: String, CodingKey {
        case id
        case user
        case downloads
        case location
        case createDate = "created_at"
        case urls
    }
}

struct SearchData: Codable {
    let results: [Results]?
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

struct Results: Codable {
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
