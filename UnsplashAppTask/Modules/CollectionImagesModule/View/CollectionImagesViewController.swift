//
//  ViewController.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit

final class CollectionImagesViewController: UIViewController {
    
    var presenter: CollectionImagesPresenter
    
    private var collectionView: UICollectionView?
    private let searchBar = UISearchController()
    private var timer: Timer?
    
    init(presenter: CollectionImagesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearch()
        presenter.viewDidLoad()
    }
}

// MARK: Setup UI

extension CollectionImagesViewController {
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 5.0
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(
            CollectionPhotoViewCell.self,
            forCellWithReuseIdentifier: CollectionPhotoViewCell.identifier
        )
        collectionView?.delegate = self
        collectionView?.dataSource = self
        self.view.addSubview(collectionView ?? UICollectionView())
    }
    
    private func setupSearch() {
        navigationItem.searchController = searchBar
        searchBar.searchResultsUpdater = self
        searchBar.delegate = self
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Search..."
    }
}

// MARK: Setup CollectionView

extension CollectionImagesViewController: UICollectionViewDelegate {}

extension CollectionImagesViewController: UICollectionViewDelegateFlowLayout {}

extension CollectionImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionPhotoViewCell.identifier,
            for: indexPath
        ) as? CollectionPhotoViewCell,
           let image = presenter.imageData[safe: indexPath.row] {
            cell.configure(image: image)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: Setup SearchBar

extension CollectionImagesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        func updateSearchResults(for searchController: UISearchController) {
            if searchController.searchBar.text?.isEmpty == false {
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    let searchText = searchController.searchBar.text
                    self.presenter.searchImages(searchText: searchText ?? "")
                }
                )
            } else {
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    self.presenter.showRandomImages()
                }
                )
            }
        }
    }
}

extension CollectionImagesViewController: UISearchControllerDelegate {}

// MARK: Delegate

// TODO: Add delegate to details viewController
extension CollectionImagesViewController {
    func passImageData(photo: Image) {
    }
    
    func deleteImageData(photo: Image) {
    }
}

// MARK: ViewInput

extension CollectionImagesViewController: CollectionImagesViewInput {
    func reloadData() {
        self.collectionView?.reloadData()
    }
}
