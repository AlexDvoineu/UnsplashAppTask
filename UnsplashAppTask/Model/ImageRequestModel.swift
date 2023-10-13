//
//  ImageRequestModel.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

struct ImageResult: Codable{
  
    let location: LocationData
    let downloads: Int?
}

struct LocationData: Codable, Hashable{
    let name: String?
}
