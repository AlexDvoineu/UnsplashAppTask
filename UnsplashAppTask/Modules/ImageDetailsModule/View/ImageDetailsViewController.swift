//
//  ImageDetailsViewController.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit
import SDWebImage

final class ImageDetailsViewController: UIViewController {
    var presenter: ImageDetailsPresenter
    
    weak var delegate: ImageDetailsViewControllerDelegate?
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let createDateLabel = UILabel()
    private let favouritesButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.checkFavourites()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        checkFavouritesButton()
    }

    init(presenter: ImageDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func favouritesButtonTapped() {
        presenter.changeButton()
        checkFavouritesButton()
    }

    private func checkFavouritesButton() {
        if favouritesButton.imageView?.image == UIImage(systemName: Constant.favouriteImage) {
            presenter.checkFavouriteButton(isFavourite: true)
        } else if presenter.fromFavouritePhoto == true &&
                    favouritesButton.imageView?.image == UIImage(systemName: Constant.unfavouriteImage) {
            presenter.checkFavouriteButton(isFavourite: false)
        }
    }
}

// MARK: Setup UI

extension ImageDetailsViewController {
    private func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        favouritesButton.translatesAutoresizingMaskIntoConstraints = false
        favouritesButton.addTarget(self, action: #selector(favouritesButtonTapped), for: .touchUpInside)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        view.addSubview(imageView)
        view.addSubview(favouritesButton)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

            favouritesButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15),
            favouritesButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            favouritesButton.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),

            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: ViewInput

extension ImageDetailsViewController: ImageDetailsViewInput {
    
    func configure(image: Image) {
        descriptionLabel.text = "\(image.description)"
        titleLabel.text = "\(image.title)"
    }
    
    func setFavourite(isFavourite: Bool) {
        if isFavourite {
            favouritesButton.setImage(UIImage(systemName: Constant.favouriteImage), for: .normal)
        } else {
            favouritesButton.setImage(UIImage(systemName: Constant.unfavouriteImage), for: .normal)
        }
    }
    
    func passImageData(image: Image) {
        delegate?.passImageData(image: image)
    }
    
    func deleteImageData(image: Image) {
        delegate?.deleteImageData(image: image)
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
}

// MARK: Delegate

protocol ImageDetailsViewControllerDelegate: AnyObject {
    func passImageData(image: Image)
    func deleteImageData(image: Image)
}

protocol ImageDetailsViewControllerFavourite: AnyObject {
    func passImageData(image: Image)
    func deleteImageData(image: Image)
}
