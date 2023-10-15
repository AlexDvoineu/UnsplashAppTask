//
//  ViewController.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import UIKit
import rswift

final class CollectionImagesViewController: DataLoadingViewController {

    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    private var timer: Timer?

    let presenter: CollectionImagesOutput

    init(presenter: CollectionImagesOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        congifureViewController()
        configureCollectionView()
        configureSearchController()
        createDismissKeyboardTapGestureRecognizer()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)

        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.basicColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}

extension CollectionImagesViewController {
    func createDismissKeyboardTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
}

extension CollectionImagesViewController {

    private func congifureViewController() {
        title = R.string.localizable.collection()
        view.backgroundColor = .systemBackground
    }

    // MARK: - Configure UI elements
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
    }

    // MARK: - Configure Search Controller
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = R.string.localizable.search()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.clearButtonMode = .never
        navigationItem.searchController = searchController
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CollectionImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell {
            let image: ImageDetails = presenter.image(at: indexPath.row)
            cell.setForRequest(image: image)

            return cell
        }
        return UICollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let alreadyScrolledDataOffsetY = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if alreadyScrolledDataOffsetY > totalContentHeight - screenHeight {
            presenter.loadNextPageIfNeeded()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image: ImageDetails = presenter.image(at: indexPath.row)

        let destinationVC = ImageDetailsAssembly.assembleImageDetailsModule(image: image, delegate: nil)
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate
extension CollectionImagesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchRequest = searchController.searchBar.text ?? ""
        presenter.searchRequest = searchRequest

        guard !searchRequest.isEmpty else {
            presenter.cancelSearching()
            return
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.presenter.searchImages(searchText: searchRequest)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.cancelSearching()
    }
}

// MARK: ViewInput

extension CollectionImagesViewController: CollectionImagesInput {
    func reloadData() {
        collectionView.reloadData()
    }
    func showError(_ error: ErrorMessages) {
        self.presentCustomAllertOnMainThred(allertTitle: R.string.localizable.something(),
                                            message: error.rawValue,
                                            butonTitle: R.string.localizable.ok())
    }
}
