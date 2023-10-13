//
//  UIViewController+Extension.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit
import SafariServices

extension UIViewController {
    func alertMessage(
        title: String,
        description: String,
        buttonDefaultTitle: String,
        buttonDestructiveTitle: String? = nil,
        handlerDestructive: @escaping (UIAlertAction) -> Void,
        handlerDefault: @escaping (UIAlertAction) -> Void
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let actionDefault = UIAlertAction(title: buttonDefaultTitle, style: .cancel, handler: handlerDefault)
        alert.addAction(actionDefault)
        if buttonDestructiveTitle != nil {
            let actionDestructive = UIAlertAction(title: buttonDestructiveTitle, style: .destructive, handler: handlerDestructive)
            alert.addAction(actionDestructive)
        }
        return alert
    }
    
    func presentCustomAllertOnMainThred(allertTitle: String, message: String, butonTitle: String){
        DispatchQueue.main.async {
            let allertVC = AllertVC(allertTitle: allertTitle, message: message, buttonTitle: butonTitle)
            allertVC.modalPresentationStyle = .overFullScreen
            allertVC.modalTransitionStyle = .crossDissolve
            self.present(allertVC, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemOrange
        present(safariVC, animated: true)
    }
}
