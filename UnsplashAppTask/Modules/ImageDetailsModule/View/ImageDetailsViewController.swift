//
//  ImageDetailsViewController.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

protocol ReloadTableProtocol {
    func reloadTableFunc()
}

struct TempImageDetails: ImageDetails {
    var id: String
    var title: String
    var description: String
    var imageUrl: URL
    var authorsName: String
}

class ImageDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    var reloadDelegate: ReloadTableProtocol?
    var presenter: ImageDetailsPresenterOutput
    
    let scrollView  = UIScrollView()
    let contentView = UIView()
    
    let imageView = ImageView(frame: .zero)
    let addFavoritesButton = Button(frame: .zero)
    let userNameLabel = TitleLabel(textAlignment: .left, fontSize: 34)
    
        // .эти два пункта под вопросом
    let updatedAtLabel = SecondaryTitleLabel(fontSize: 18)
    let locationAndDowloadsLabel = SecondaryTitleLabel(fontSize: 18)
    
    let imageTitleLabel = SecondaryTitleLabel(fontSize: 18)
    let imageDescriptionLabel = SecondaryTitleLabel(fontSize: 18)
    
    
    var updatedAt: Date = Date()
    var likes: Int = 0
    
    init(presenter: ImageDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureButtons()
        configureScrollView()
        layoutUI()
        
        presenter.viewDidLoad()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = Colors.basicColor
        navigationItem.rightBarButtonItem = doneButton
    }
    
 //MARK: -  Configure Views
    
    private func configureButtons() {
        addFavoritesButton.addTarget(self, action: #selector(addFavoritesButtonTapped), for: .touchUpInside)
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    //MARK: - Load Image Data From API
    private func getImageData(id: String) {
        NetworkManager.shared.getImagesByID(for: id) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.locationAndDowloadsLabel.text = "\(data.location.name ?? "No info about description") \nDownloads: \(String(describing: data.downloads ?? 0))"
                }
                
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    //MARK: - Configure actions for buttons
    @objc func dismissVC() {
        self.reloadDelegate?.reloadTableFunc()
        dismiss(animated: true)
    }
    
    @objc func addFavoritesButtonTapped() {
        presenter.favoriteButtonTapped()
    }
    

    
    //MARK: - Configure Views Layouts
    private func layoutUI() {
        
        contentView.addSubviews(
            imageView,
            addFavoritesButton,
            userNameLabel,
            locationAndDowloadsLabel,
            imageTitleLabel,
            imageDescriptionLabel)
        
        let padding: CGFloat = 20
        
        addFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        updatedAtLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationAndDowloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            
            userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            locationAndDowloadsLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2*padding),
            locationAndDowloadsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            locationAndDowloadsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            locationAndDowloadsLabel.heightAnchor.constraint(equalToConstant: 60),
            
            addFavoritesButton.topAnchor.constraint(equalTo: locationAndDowloadsLabel.bottomAnchor, constant: 2*padding),
            addFavoritesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            addFavoritesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            addFavoritesButton.heightAnchor.constraint(equalToConstant: 60),
            
            imageTitleLabel.topAnchor.constraint(equalTo: addFavoritesButton.bottomAnchor, constant: padding),
            imageTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageTitleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            imageDescriptionLabel.topAnchor.constraint(equalTo: imageTitleLabel.bottomAnchor, constant: padding),
            imageDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            imageDescriptionLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension ImageDetailsViewController: ImageDetailsViewInput {
    func configure(image: ImageDetails) {
        userNameLabel.text = "Author: \(image.authorsName)"
        getImageData(id: image.id)
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    
    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: "Already in Favorites", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete from Favorites", style: .destructive , handler:{ [weak self] (UIAlertAction) in
            
            completion(true)
            self?.reloadDelegate?.reloadTableFunc()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{  (UIAlertAction) in
            completion(false)
        }))
        
        self.present(alert, animated: true)
    }
    
    func showSuccesSavedAlert() {
        presentCustomAllertOnMainThred(allertTitle: "Success", message: "You have successfully added this image to favorites", butonTitle: "Ok")
        
        reloadDelegate?.reloadTableFunc()
    }
    
    func setFavouriteState(isFavourite: Bool) {
        if isFavourite {
            addFavoritesButton.set(backgroundColor: .systemRed, title: "Delete From  Favorites")
        } else {
            addFavoritesButton.set(backgroundColor: .systemGreen, title: "Add to favorites")
        }
    }
}
