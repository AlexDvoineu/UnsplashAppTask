//
//  ImageDownloaderProtocolTestDouble.swift
//  UnsplashAppTaskTests
//
//  Created by Aliaksandr Dvoineu on 14.10.23.
//

@testable import UnsplashAppTask
import UIKit

final class ImageDownloaderProtocolTestDouble: ImageDownloaderProtocol {

    var downloadImageWithUrlCompletionCallsCount: Int = .zero
    var downloadImageWithUrlCompletionIsCalled: Bool {
        downloadImageWithUrlCompletionCallsCount > .zero
    }
    var downloadImageWithUrlCompletionUrl: URL?
    var downloadImageWithUrlCompletionReturnValue: UIImage?

    func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        downloadImageWithUrlCompletionCallsCount += 1
        downloadImageWithUrlCompletionUrl = url
        completion(downloadImageWithUrlCompletionReturnValue)
    }
}
