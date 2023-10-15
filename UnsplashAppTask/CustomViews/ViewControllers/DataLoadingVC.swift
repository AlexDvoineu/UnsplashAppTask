//
//  DataLoadingVC.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

class DataLoadingVC: UIViewController {
    
    lazy var containerView = UIView(frame: view.bounds)
    let emptyStateView = EmptyStateView(message: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyStateView)
    }
    
    func showLoadingView() {
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        emptyStateView.massage = message
        emptyStateView.frame = view.bounds
        emptyStateView.isHidden = false
    }
    
    func hideEmptyStateView() {
        emptyStateView.isHidden = true
    }
    
}
