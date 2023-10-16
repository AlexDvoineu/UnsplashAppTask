//
//  FavouriteImagesTableViewCell.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

final class FavouriteImagesTableViewCell: UITableViewCell {

    private let image = ImageView(frame: .zero)
    private let authorNameLabel = SecondaryTitleLabel(fontSize: 18)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageUrl: URL, userName: String) {
        image.sd_setImage(with: imageUrl)
        authorNameLabel.text = R.string.localizable.authorsName() + "\n\(userName)"
    }

    private func setupUI() {
        addSubviews(image, authorNameLabel)
        image.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        let padding: CGFloat = 20
        
        accessoryType = .disclosureIndicator
         
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 150),
            
            authorNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: padding),
            authorNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
}

extension FavouriteImagesTableViewCell: Reusable {}
