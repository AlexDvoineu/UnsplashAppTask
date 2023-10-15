//
//  DataLoadingVC.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

class DataLoadingViewController: UIViewController {

    lazy var containerView = UIView(frame: view.bounds)
    let emptyStateView = EmptyStateView(message: "")

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
        view.addSubview(emptyStateView)
    }

    func hideEmptyStateView() {
        emptyStateView.removeFromSuperview()
    }

}
