//
//  CollectionImagesPresenterProtocol.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import Foundation

protocol CollectionImagesOutput: AnyObject {
    func viewDidLoad()

    var searchRequest: String { get set }
    func searchImages(searchText: String)
    func loadNextPageIfNeeded()
    func cancelSearching()

    func image(at index: Int) -> ImageDetails
    var numberOfItems: Int { get }
}
