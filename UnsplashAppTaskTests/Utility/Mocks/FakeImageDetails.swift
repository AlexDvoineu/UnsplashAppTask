//
//  FakeImageDetails.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import Foundation

struct FakeImageDetails: ImageDetails {
    let id: String
    let title: String
    let description: String
    let imageUrl: URL
    let authorsName: String
}

