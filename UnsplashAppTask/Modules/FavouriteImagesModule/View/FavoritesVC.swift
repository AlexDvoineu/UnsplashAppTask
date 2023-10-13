//
//  FavoritesVC.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

class FavoritesVC: DataLoadingVC {
    
    let tableView = UITableView()
    
    var favoritesArray = PersistenceManager.sharedRealm.item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
        checkImagesCount()
    }
    
    private func checkImagesCount(){
        if favoritesArray.count == 0{
            
            DispatchQueue.main.async {
                self.showEmptyStateView(with: "No favorites", in: self.view)
            }
        }
    }
    
    func reloadTableView(){
        favoritesArray = PersistenceManager.sharedRealm.item
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.basicColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 250
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = Colors.basicColor
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoritesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        
        let favorite = favoritesArray[indexPath.row]
        cell.set(imageUrl: favorite.imageUrl, userName: favorite.authorsName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favoritesArray[indexPath.row]
        let destinationVC   = ImageInfoVC()
        destinationVC.reloadDelegate = self
        
        destinationVC.authorsName       = favorite.authorsName
        destinationVC.imageUrl          = favorite.imageUrl
        destinationVC.updatedAt         = favorite.updatedAt
        destinationVC.userHTML          = favorite.userHTML
        destinationVC.likes             = favorite.likes
        destinationVC.idOfImage         = favorite.idOfImage
        
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else{return}
        let favorite = favoritesArray[indexPath.row]
        PersistenceManager.sharedRealm.deleteFavorite(item: favorite)
        reloadTableView()
        checkImagesCount()
    }
}


extension FavoritesVC: ReloadTableProtocol{
    func reloadTableFunc() {
        reloadTableView()
        checkImagesCount()
    }
}
