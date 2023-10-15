//
//  CollectionImagesPresenter.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import UIKit

final class CollectionImagesPresenter {

    weak var view: CollectionImagesInput?

    #warning("Choose your fighter")
    private var networkService = NetworkService()
    private let apiManager: APIManagerProtocol

    private var requestImagesResults: [ImagesResult] = []
    private var randomImagesResults: [RandomImagesResult] = []

    private var isSearchingByRandom = true
    private var isLoadingMoreImages = false
    private var shouldLoadMoreImages = true

    var searchRequest = ""
    var page = 1

    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
}

extension CollectionImagesPresenter: CollectionImagesOutput {
    func viewDidLoad() {
        view?.showLoadingView()
        getRandomImages(page: page)
    }

    func cancelSearching() {
        setupDefaultState()
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

    func loadNextPageIfNeeded() {
        guard shouldLoadMoreImages, !isLoadingMoreImages, !isSearchingByRandom else { return }
        page += 1
        getImagesByRequest(request: searchRequest, page: page)
        shouldLoadMoreImages = false
    }

    var numberOfItems: Int {
        isSearchingByRandom ? randomImagesResults.count : requestImagesResults.count
    }

    func image(at index: Int) -> ImageDetails {
        isSearchingByRandom ? randomImagesResults[index] : requestImagesResults[index]
    }
}

private extension CollectionImagesPresenter {
    func setupDefaultState() {
        requestImagesResults.removeAll()
        isSearchingByRandom = true
        view?.reloadData()
    }

    func getRandomImages(page: Int) {
        isSearchingByRandom = true
        shouldLoadMoreImages = false

        apiManager.getRandomImages(
            page: page
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
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

        apiManager.getImagesByRequest(
            for: request,
            page: page
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                self.view?.dismissLoadingView()

                switch result {
                    case .success(let resultsImages):
                        self.shouldLoadMoreImages = resultsImages.results.count >= 30
                        self.requestImagesResults.append(contentsOf: resultsImages.results)
                    case .failure(let error):
                        self.view?.showError(error)
                }

                self.isLoadingMoreImages = false
                self.view?.reloadData()
            }
        }
    }
}
