//
//  ImageCell.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    
    static let reuseID = "ImageCell"
    
    let imageImageView = ImageView(frame: .zero)
    var cellId = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageImageView.image = Images.placeholder
    }
    
    func setDefaultImage(){
        imageImageView.image = Images.placeholder
    }
    
    func setForRequest(image: ImagesResult){
        setDefaultImage()
        self.imageImageView.downloadImage(fromURL: image.urls.thumb)
    }

    func setForRandom(image: RandomImagesResult){
        setDefaultImage()
        self.imageImageView.downloadImage(fromURL: image.urls.thumb)
    }
    
    private func configure(){
        imageImageView.frame = contentView.bounds
        addSubview(imageImageView)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            imageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageImageView.heightAnchor.constraint(equalTo: imageImageView.widthAnchor)
        ])
    }
}
