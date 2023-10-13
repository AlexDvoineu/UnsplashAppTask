//
//  CollectionImagesViewCell.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import UIKit
import SDWebImage

class CollectionImagesViewCell: UICollectionViewCell {
    static let identifier = "collectionImagesViewCell"

    private let picture = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        picture.clipsToBounds = true
        picture.contentMode = .scaleAspectFill
        picture.translatesAutoresizingMaskIntoConstraints = false
        addSubview(picture)

        NSLayoutConstraint.activate([
            picture.rightAnchor.constraint(equalTo: rightAnchor),
            picture.leftAnchor.constraint(equalTo: leftAnchor),
            picture.topAnchor.constraint(equalTo: topAnchor),
            picture.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(image: Image) {
        NetworService().downloadImage(url: image.smallPhoto) { [weak self] image in
            guard let self = self else { return }
            self.picture.image = image
        }
    }
}
