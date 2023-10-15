//
//  CollectionImagesPresenter.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import UIKit

final class CollectionImagesPresenter: CollectionImagesOutput {
    
    weak var view: CollectionImagesInput?
    private var networkService = NetworService()
    
    private var requestImagesResults: [ImagesResult] = []
    private var randomImagesResults:  [RandomImagesResult] = []
    
    var isSearchingByRandom = true
    var isLoadingMoreImages = false
    var moreImages = true
    
    var searchRequest = ""
    var page = 1
    
    func viewDidLoad() {
        view?.showLoadingView()
        getRandomImages(page: page)
    }
    
    func cancelSearching() {
        setupDefaultState()
    }
    
    private func setupDefaultState() {
        requestImagesResults.removeAll()
        isSearchingByRandom = true
        view?.reloadData()
    }
    
    func searchImages(searchText: String) {
        searchRequest = searchText
        
        guard !searchText.isEmpty else {
            setupDefaultState()
            return
        }
        
        page = 1
        requestImagesResults.removeAll()
        getImagesByRequest(request: searchText, page: page)
    }
    
    func getRandomImages(page: Int) {
        isSearchingByRandom = true
        moreImages = false
        
        NetworkManager.shared.getRandomImages(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.dismissLoadingView()
                
                switch result {
                case .success(let randomImagesResult):
                    self.randomImagesResults.removeAll()
                    self.randomImagesResults = randomImagesResult
                    self.view?.reloadData()
                    
                case .failure(let error):
                    self.view?.showError(error)
                }
            }
        }
    }
    
    
    func getImagesByRequest(request: String, page: Int) {
        isSearchingByRandom = false
        isLoadingMoreImages = true
        view?.showLoadingView()
        
        NetworkManager.shared.getImagesByRequest(for: request, page: page)  { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.dismissLoadingView()
                
                switch result {
                case .success(let resultsImages):
                    if resultsImages.results.count < 30 { self.moreImages = false }
                    else { self.moreImages = true }
                    self.requestImagesResults.append(contentsOf: resultsImages.results)
                case .failure(let error):
                    self.view?.showError(error)
                }
                
                self.view?.reloadData()
                self.isLoadingMoreImages = false
            }
        }
    }
    
    func loadNextPageIfNeeded() {
        guard moreImages, !isLoadingMoreImages, !isSearchingByRandom else { return }
        page += 1
        getImagesByRequest(request: searchRequest, page: page)
        moreImages = false
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        isSearchingByRandom ? randomImagesResults.count : requestImagesResults.count
    }
    
    func getItem(at indexPath: IndexPath) -> ImageDetails {
        isSearchingByRandom ? randomImagesResults[indexPath.item] : requestImagesResults[indexPath.item]
    }
}
