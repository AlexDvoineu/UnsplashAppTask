//
//  ImageDownloader.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

import UIKit
import SDWebImage

protocol ImageDownloaderProtocol {
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageDownloader {
    private let downloader: SDWebImageDownloader

    init(downloader: SDWebImageDownloader = .shared) {
        self.downloader = downloader
    }
}

extension ImageDownloader: ImageDownloaderProtocol {
    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        downloader.downloadImage(with: url) { image, _, _, _ in
            completion(image)
        }
    }
}
