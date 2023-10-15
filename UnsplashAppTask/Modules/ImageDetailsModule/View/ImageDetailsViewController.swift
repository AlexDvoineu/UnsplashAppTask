//
//  ImageDetailsViewController.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

protocol ReloadTableProtocol {
    func reloadTableData()
}

class ImageDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    var reloadDelegate: ReloadTableProtocol?
    var presenter: ImageDetailsPresenterOutput
    
    let scrollView = UIScrollView()
    lazy var contentStackView = UIStackView(arrangedSubviews: [
        imageView,
        userNameLabel,
        locationAndDowloadsLabel,
        addFavoritesButton
    ])
    
    let imageView = ImageView(frame: .zero)
    let userNameLabel = TitleLabel(textAlignment: .left, fontSize: 34)
    let locationAndDowloadsLabel = SecondaryTitleLabel(fontSize: 18)
    let addFavoritesButton = Button(frame: .zero)
    
    
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
    
    //MARK: - Configure actions for buttons
    @objc func dismissVC() {
        reloadDelegate?.reloadTableData()
        dismiss(animated: true)
    }
    
    @objc func addFavoritesButtonTapped() {
        presenter.favoriteButtonTapped()
    }
    
    //MARK: - Configure Views Layouts
    private func layoutUI() {
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view)

        let padding: CGFloat = 20
        
        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .fill
        contentStackView.spacing = 2*padding
        contentStackView.setCustomSpacing(padding, after: imageView)

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        addFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationAndDowloadsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            contentStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -padding*2),
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -padding*3),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            locationAndDowloadsLabel.heightAnchor.constraint(equalToConstant: 60),
            addFavoritesButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension ImageDetailsViewController: ImageDetailsViewInput {
    func configure(image: ImageDetails, location: String?, downloads: Int) {
        userNameLabel.text = "Author: \(image.authorsName)"
        locationAndDowloadsLabel.text = "\(location ?? "No info about description") \nDownloads: \(String(describing: downloads))"
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    
    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: "Already in Favorites", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete from Favorites", style: .destructive , handler:{ [weak self] (UIAlertAction) in
            completion(true)
            self?.reloadDelegate?.reloadTableData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{  (UIAlertAction) in
            completion(false)
        }))
        
        self.present(alert, animated: true)
    }
    
    func showSuccesSavedAlert() {
        presentCustomAllertOnMainThred(allertTitle: "Success", message: "You have successfully added this image to favorites", butonTitle: "Ok")
        
        reloadDelegate?.reloadTableData()
    }
    
    func setFavouriteState(isFavourite: Bool) {
        if isFavourite {
            addFavoritesButton.set(backgroundColor: .systemRed, title: "Delete From  Favorites")
        } else {
            addFavoritesButton.set(backgroundColor: .systemGreen, title: "Add to favorites")
        }
    }
    
    func showError(_ error: ErrorMessages) {
        self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
    }
}
