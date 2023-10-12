//
//  CollectionImagesPresenter.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit

final class CollectionImagesPresenter: CollectionImagesPresenterProtocol {
    
    weak var view: CollectionImagesViewInput?
    
    var imageData: [Image] = []
    private var randomImageData: [Image] = []
    
    
    func viewDidLoad() {
        fetchImages()
//        showRandomImages()
    }
    
    func searchImages(searchText: String) {
        NetworkManager().fetchData(
            requestType: .search(searchTerms: searchText)
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.imageData = image
                self.view?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showRandomImages() {
        if imageData != randomImageData {
            imageData = randomImageData
            view?.reloadData()
        }
    }
    
    private func fetchImages() {
        NetworkManager().fetchData(
            requestType: .random
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.imageData = image
                self.randomImageData = image
                self.view?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
