//
//  ImageCell.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    private lazy var imageImageView = ImageView(frame: .zero)

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
        imageImageView.sd_cancelCurrentImageLoad()
        imageImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageImageView.frame = contentView.bounds
    }

    func setDefaultImage() {
        imageImageView.image = nil
        imageImageView.image = Images.placeholder
    }

    func setForRequest(image: ImageDetails) {
        setDefaultImage()
        imageImageView.sd_setImage(with: image.imageUrl)
    }

    private func configure() {
        addSubview(imageImageView)
    }
}

extension ImageCell: Reusable {}
