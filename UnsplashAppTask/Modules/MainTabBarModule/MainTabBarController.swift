//
//  MainTabBarController.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewcontroller: CollectionImagesViewController(), title: "Collection", imageName: "photo"),
            createNavController(viewcontroller: FavouriteImagesViewController(), title: "Favourites", imageName: "heart")
        ]
    }
    
    fileprivate func createNavController(viewcontroller: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewcontroller)
        viewcontroller.navigationItem.title = title
        viewcontroller.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}

struct MainTabBarController_Previews: PreviewProvider {
    
    static var previews: some View {
        Container()
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> MainTabBarController {
            MainTabBarController()
        }
        
        func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {
            
        }
        
        typealias UIViewControllerType = MainTabBarController
        
    }
}
