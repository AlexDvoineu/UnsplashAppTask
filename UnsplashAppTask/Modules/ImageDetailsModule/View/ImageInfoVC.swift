//
//  ImageInfoVC.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

protocol ReloadTableProtocol {
    func reloadTableFunc()
}


class ImageInfoVC: UIViewController, UIScrollViewDelegate {
    
    var reloadDelegate: ReloadTableProtocol?
    
    let scrollView  = UIScrollView()
    let contentView = UIView()
    
    let imageImageView                  = ImageView(frame: .zero)
    let addFavoritesButton              = Button(frame: .zero)
    let userNameLabel                   = TitleLabel(textAlignment: .left, fontSize: 34)
    let updatedAtLabel                  = SecondaryTitleLabel(fontSize: 18)
    let locationAndDowloadsLabel        = SecondaryTitleLabel(fontSize: 18)
    let imageDescriptionLabel           = SecondaryTitleLabel(fontSize: 18)
    
    var imageUrl:    String!
    var authorsName: String!
    var updatedAt:   Date!
    var userHTML:    String!
    var idOfImage:   String!
    var likes:       Int!
    var imageDescription: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        configureLabels()
        configureButtons()
        configureImage()
        layoutUI()
    }
    
    func configureVC(){
        view.backgroundColor    = .systemBackground
        let doneButton          = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor    = Colors.basicColor
        navigationItem.rightBarButtonItem = doneButton
    }
    
 //MARK: -  Configure Views
    private func configureLabels(){
        userNameLabel.text  = "Author: \(authorsName ?? "")"
        imageDescriptionLabel.text = "Description: \(imageDescription ?? "")"
//        updatedAtLabel.text = "Updated at: )"
        getImageData(id: idOfImage ?? "")
    }
    
    private func configureButtons(){
        addFavoritesButton.addTarget(self, action: #selector(addFavoritesButtonTapped), for: .touchUpInside)
        guard !PersistenceManager.sharedRealm.objectExist(primaryKey: idOfImage) else{
            addFavoritesButton.set(backgroundColor: .systemRed, title: "Delete From  Favorites")
            return}
        
        addFavoritesButton.set(backgroundColor: .systemGreen, title: "Add to favorites")
    }
    
    private func configureImage(){
        imageImageView.downloadImage(fromURL: imageUrl)
    }
    
    func configureScrollView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
        
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    //MARK: - Load Image Data From API
    private func getImageData(id: String){
        NetworkManager.shared.getImagesByID(for: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let loadedData):
                DispatchQueue.main.async {
                    self.locationAndDowloadsLabel.text = "\(loadedData.location.name ?? "No info about description") \nDownloads: \(String(describing: loadedData.downloads ?? 0))"
                }
                
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
            
        }
    }
    
    //MARK: - Configure actions for buttons
    @objc func dismissVC(){
        self.reloadDelegate?.reloadTableFunc()
        dismiss(animated: true)
    }
    
    
    @objc func addFavoritesButtonTapped(){
        
        addFavoritesButton.set(backgroundColor: .systemRed, title: "Delete From  Favorites")
        
        guard !PersistenceManager.sharedRealm.objectExist(primaryKey: idOfImage) else{
            
            //AllertController
            let alert = UIAlertController(title: "", message: "Already in Favorites", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Delete from Favorites", style: .destructive , handler:{ (UIAlertAction)in
                
                
                PersistenceManager.sharedRealm.deleteData(idForDelete: self.idOfImage)//here realm
                self.reloadDelegate?.reloadTableFunc()
                self.addFavoritesButton.set(backgroundColor: .systemGreen, title: "Add to favorites")
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
                
            }))
            
            self.present(alert, animated: true, completion: {
            })
            
            return}//checking if object already exists
        
        self.presentCustomAllertOnMainThred(allertTitle: "Success", message: "You have successfully added this image to favorites", butonTitle: "Ok")
        
        PersistenceManager.sharedRealm.addFavorite(authorsName: authorsName, imageUrl: imageUrl, updatedAt: updatedAt, userHTML: userHTML, likes: likes, id: idOfImage)//adding new object
        self.reloadDelegate?.reloadTableFunc()
    }
    
    
    @objc func userInfoTapped(){
        guard let url = URL(string: userHTML) else{
            presentCustomAllertOnMainThred(allertTitle: "Invalid URL", message: "This URL is invalid", butonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
    
    //MARK: - Configure Views Layouts
    private func layoutUI(){
        
        contentView.addSubviews(imageImageView, addFavoritesButton, userNameLabel, updatedAtLabel, locationAndDowloadsLabel)
        
        let padding: CGFloat = 20
        
        addFavoritesButton.translatesAutoresizingMaskIntoConstraints        = false
        imageImageView.translatesAutoresizingMaskIntoConstraints            = false
        updatedAtLabel.translatesAutoresizingMaskIntoConstraints            = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints             = false
        locationAndDowloadsLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        NSLayoutConstraint.activate([
            
            imageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageImageView.heightAnchor.constraint(equalToConstant: 300),
            imageImageView.widthAnchor.constraint(equalToConstant: 300),
            
            userNameLabel.topAnchor.constraint(equalTo: imageImageView.bottomAnchor, constant: padding),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            
            addFavoritesButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2*padding),
            addFavoritesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            addFavoritesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            addFavoritesButton.heightAnchor.constraint(equalToConstant: 60),
            
            
            updatedAtLabel.topAnchor.constraint(equalTo: addFavoritesButton.bottomAnchor, constant: padding),
            updatedAtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            updatedAtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            updatedAtLabel.heightAnchor.constraint(equalToConstant: 60),
            
            locationAndDowloadsLabel.topAnchor.constraint(equalTo: updatedAtLabel.bottomAnchor, constant: padding),
            locationAndDowloadsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            locationAndDowloadsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            locationAndDowloadsLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

