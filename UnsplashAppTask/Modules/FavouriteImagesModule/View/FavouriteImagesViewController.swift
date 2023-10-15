//
//  FavouriteImagesController.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit

class FavouriteImagesViewController: DataLoadingVC {
    var presenter: FavouriteImagesPresenter
    let tableView = UITableView()
    
    init(presenter: FavouriteImagesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        needReloadTableView()
    }
    
    private func showPlaceholderIfNeeded(_ count: Int) {
        if count == 0 {
            showEmptyStateView(with: "No favorites", in: self.view)
        } else {
            hideEmptyStateView()
        }
    }
    
    func needReloadTableView() {
        presenter.updateData()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.basicColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 250
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = Colors.basicColor
        tableView.backgroundColor = .clear
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension FavouriteImagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.favoritesArray.count
        showPlaceholderIfNeeded(count)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = presenter.favoritesArray[indexPath.row]
        cell.set(imageUrl: favorite.imageUrl, userName: favorite.authorsName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = presenter.favoritesArray[indexPath.row]
        let image = TempImageDetails(image: favorite)
        let destinationVC = ImageDetailsAssembly.assembleImageDetailsModule(image: image, delegate: self)
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

extension FavouriteImagesViewController: ReloadTableProtocol {
    func reloadTableData() {
        needReloadTableView()
    }
}

extension FavouriteImagesViewController: FavouriteImagesInput {
    func reloadData() {
        tableView.reloadData()
    }
}
