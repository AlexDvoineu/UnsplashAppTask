//
//  UIViewController+Extension.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentCustomAllertOnMainThred(allertTitle: String, message: String, butonTitle: String) {
        DispatchQueue.main.async {
            let allertVC = AllertVC(allertTitle: allertTitle, message: message, buttonTitle: butonTitle)
            allertVC.modalPresentationStyle = .overFullScreen
            allertVC.modalTransitionStyle = .crossDissolve
            self.present(allertVC, animated: true)
        }
    }
}
