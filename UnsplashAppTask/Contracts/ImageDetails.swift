//
//  ImageDetails.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

import Foundation

protocol ImageDetails {
    var id: String { get }
    var title: String { get }
    var description: String { get }
    var imageUrl: URL { get }
    var authorsName: String { get }
}
