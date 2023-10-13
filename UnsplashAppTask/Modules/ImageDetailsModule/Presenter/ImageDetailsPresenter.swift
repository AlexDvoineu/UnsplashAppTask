//
//  ImageDetailsPresenter.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation
import SDWebImage

final class ImageDetailsPresenter: ImageDetailsPresenterProtocol {
    weak var view: ImageDetailsViewInput?
    var image: Image?
    var fromFavouritePhoto = false
    var isFavourite = false
    
    func viewDidLoad() {
        guard let image = image else { return }
        view?.configure(image: image)
        uploadImage()
        checkFavourites()
    }
    
    func setupDate(image: Image) -> String {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: image.createDate) ?? Date()
        let convertDate = DateFormatter()
        convertDate.dateFormat = "dd MMMM yyyy hh:mm"
        convertDate.locale = Locale(identifier: "en_EN")
        let finalDate = convertDate.string(from: date)
        return finalDate
    }
    
    func checkFavouriteButton(isFavourite: Bool) {
        guard let image = image else { return }
        if isFavourite {
            let imageData = ImagesStorage.shared.loadNotes()
            if !imageData.contains(where: { $0.id == image.id }) {
                ImagesStorage.shared.appendPhoto([image])
                view?.passImageData(image: image)
            }
        } else {
            view?.deleteImageData(image: image)
        }
    }
    
    func checkFavourites() {
        let imageData = ImagesStorage.shared.loadNotes()
        imageData.contains(where: { $0.id == image?.id }) ? (isFavourite = true) : (isFavourite = false)
        view?.setFavourite(isFavourite: isFavourite)
    }
    
    func changeButton() {
        isFavourite.toggle()
        view?.setFavourite(isFavourite: isFavourite)
    }
    
    private func uploadImage() {
        NetworService().downloadImage(url: image?.smallPhoto ?? "") { [weak self] image in
            guard let self = self else { return }
            self.view?.setImage(image: image)
        }
    }
}
