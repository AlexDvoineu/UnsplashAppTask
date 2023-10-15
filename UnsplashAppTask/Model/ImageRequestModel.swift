//
//  ImageRequestModel.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

struct ImageResult: Codable {
  
    let location: LocationData
    let downloads: Int?
    let topics: [Topics]
    let description: String?
}

struct LocationData: Codable, Hashable {
    let name: String?
}

struct Topics: Codable, Hashable {
    let title: String?
}
