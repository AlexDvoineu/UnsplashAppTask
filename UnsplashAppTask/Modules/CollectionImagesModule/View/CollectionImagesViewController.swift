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
    
    init(presenter: CollectionImagesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        presenter.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: Setup UI

// MARK: Setup SearchBar

// MARK: Delegate

// MARK: ViewInput
