//
//  MainTabBarAssembly.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit

struct MainTabBarAssembly {
    static func assembleMainTabBarModule() -> UITabBarController {
        let controller = MainTabBarController()
        
        guard let collectionImages = UIImage(systemName: Constant.collectionImage) else { return UITabBarController() }
        let collectionImagesVC = Self.generateViewController(
            viewController: CollectionImagesAssembly.assembleCollectionImagesModule(),
            image: collectionImages,
            title: "Collection"
        )
        
        guard let favouriteImages = UIImage(systemName: Constant.unfavouriteImage) else { return UITabBarController() }
        let favouriteImagesVC = Self.generateViewController(
            viewController: FavouriteImagesAssembly.assembleFavouriteImagesModule(),
            image: favouriteImages,
            title: "Favourites"
        )
        
        controller.setViewControllers([collectionImagesVC, favouriteImagesVC], animated: true)
        return controller
    }
    
    static func generateViewController(
        viewController: UIViewController,
        image: UIImage,
        title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        viewController.navigationItem.title = title
        navigationVC.navigationBar.backgroundColor = .white
        navigationVC.navigationBar.tintColor = .black
        return navigationVC
    }
}
