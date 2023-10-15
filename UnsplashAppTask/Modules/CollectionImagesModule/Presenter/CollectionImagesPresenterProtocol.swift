//
//  CollectionImagesPresenterProtocol.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import Foundation

protocol CollectionImagesOutput {
    func viewDidLoad()
    
    var searchRequest: String { get set }
    func searchImages(searchText: String)
    func loadNextPageIfNeeded()
    func cancelSearching()
    
    func getItem(at indexPath: IndexPath) -> ImageDetails
    func numberOfItemsInSection(_ section: Int) -> Int
}
