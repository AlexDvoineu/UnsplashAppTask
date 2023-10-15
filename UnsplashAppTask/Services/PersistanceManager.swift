//
//  PersistanceManager.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import Foundation
import RealmSwift

final class RealmImage: Object {
    @Persisted dynamic var id = ""
    @Persisted dynamic var title = ""
    @Persisted dynamic var imageDescription = ""
    @Persisted dynamic var authorsName = ""
    @Persisted dynamic var urlString = ""
    var imageUrl: URL { URL(string: urlString)! }
    @Persisted dynamic var updatedAt: Date
    override static func primaryKey() -> String? { return "id" }
    @Persisted(primaryKey: true) var objectId: ObjectId//for sorting
}

extension RealmImage: ImageDetails {
    override var description: String {
        imageDescription
    }
}

final class PersistenceManager {
    static let sharedRealm = PersistenceManager()
    
    private let realm = try! Realm()
    
    var realmImages: Results<RealmImage> { return realm.objects(RealmImage.self).sorted(byKeyPath: "objectId", ascending: false) }
    
    func objectExist (primaryKey: String) -> Bool {
        return realm.object(ofType: RealmImage.self, forPrimaryKey: primaryKey) != nil
    }
    
    func addFavorite(id: String, title: String, imageDescription: String, authorsName: String, imageUrl: String, updatedAt: Date = Date()) {
        let favoriteImage = RealmImage()
        favoriteImage.id = id //primary key
        favoriteImage.title = title
        favoriteImage.imageDescription = imageDescription
        favoriteImage.authorsName = authorsName
        favoriteImage.urlString = imageUrl
        favoriteImage.updatedAt = updatedAt
        
        try! realm.write { realm.add(favoriteImage) }
    }
    
    func deleteData(idForDelete: String) {
        let data = realm.object(ofType: RealmImage.self, forPrimaryKey: idForDelete)
        if let data {
            try? realm.write {
                realm.delete(data)
            }
        }
    }
}

extension PersistenceManager: FavouritesStorage {
    var items: [ImageDetails] {
        Array(realmImages)
    }
    
    func imageExist(id: String) -> Bool {
        objectExist(primaryKey: id)
    }
    
    func addImage(_ image: ImageDetails) {
        addFavorite(id: image.id,
                    title: image.title,
                    imageDescription: image.description,
                    authorsName: image.authorsName,
                    imageUrl: image.imageUrl.absoluteString)
    }
    
    func removeImage(id: String) {
        deleteData(idForDelete: id)
    }
    
}
