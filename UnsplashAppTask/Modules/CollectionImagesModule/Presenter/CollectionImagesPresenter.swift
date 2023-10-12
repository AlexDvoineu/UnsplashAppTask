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
    }
    
    private func fetchImages() {
        
    }
}
