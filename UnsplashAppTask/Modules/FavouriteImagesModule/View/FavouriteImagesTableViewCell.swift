//
//  FavouriteImagesTableViewCell.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

final class FavouriteImagesTableViewCell: UITableViewCell {
    static let identifier = "favouriteImagesTableViewCell"

    private let image = UIImageView()
    private let authorNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.font = .systemFont(ofSize: 24)

        addSubview(image)
        addSubview(authorNameLabel)

        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 100),

            authorNameLabel.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            authorNameLabel.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 40)
        ])
    }

    func configure(image: Image) {
        authorNameLabel.text = image.authorName
        NetworkService().downloadImage(url: image.smallPhoto) { [weak self] image in
            guard let self = self else { return }
            self.image.image = image
        }
    }
}
