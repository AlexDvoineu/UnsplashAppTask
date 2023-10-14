//
//  FavoriteCell.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

final class FavoriteCell: UITableViewCell {
    
    static let reuseID = "FavoriteCell"
    let imageImageView = ImageView(frame: .zero)
    let userNameLabel = SecondaryTitleLabel(fontSize: 18)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageUrl: String, userName: String) {
        imageImageView.sd_setImage(with: URL(string: imageUrl))
        userNameLabel.text = "Authors name: \n\(userName)"
    }
    
    private func configure() {
        addSubviews(imageImageView, userNameLabel)
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints  = false
        
        let padding: CGFloat = 20
        
        accessoryType = .disclosureIndicator
         
        NSLayoutConstraint.activate([
            imageImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            imageImageView.heightAnchor.constraint(equalToConstant: 150),
            imageImageView.widthAnchor.constraint(equalToConstant: 150),
            
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: imageImageView.trailingAnchor, constant: padding),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
    }
}
