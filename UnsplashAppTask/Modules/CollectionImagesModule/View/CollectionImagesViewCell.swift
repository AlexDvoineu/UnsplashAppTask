//
//  CollectionImagesViewCell.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import UIKit
import SDWebImage

class CollectionImagesViewCell: UICollectionViewCell {
    static let identifier = "collectionImagesViewCell"

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    func configure(image: Image) {
        imageView.sd_setImage(with: URL(string: image.smallPhoto))
    }
}

private extension CollectionImagesViewCell {
    func setupCell() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
