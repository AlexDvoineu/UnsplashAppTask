//
//  ImageCell.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

final class CollectionImagesViewCell: UICollectionViewCell {
    private lazy var imageView = ImageView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultImage()
        imageView.sd_cancelCurrentImageLoad()
        imageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }

    func setDefaultImage() {
        imageView.image = nil
        imageView.image = Images.placeholder
    }

    func setForRequest(image: ImageDetails) {
        setDefaultImage()
        imageView.sd_setImage(with: image.imageUrl)
    }

    private func configure() {
        addSubview(imageView)
    }
}

extension CollectionImagesViewCell: Reusable {}
