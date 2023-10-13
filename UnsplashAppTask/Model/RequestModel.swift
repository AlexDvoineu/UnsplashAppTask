//
//  RequestModel.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import Foundation

//struct APIResponse: Codable, Hashable{
//    let results: [ImagesResult]
//}






//struct ImagesResult: Codable{
//    let uuid = UUID()
//    let id: String
//    let likes: Int
//    let updatedAt: Date
//    let urls: URLS
//    let user: UsersByRequest
//    
//    private enum CodingKeys : String, CodingKey { case  id, likes, user, updatedAt, urls }
//}
//
//extension ImagesResult: Hashable{
//    static func ==(lhs: ImagesResult, rhs: ImagesResult) -> Bool {
//        return lhs.uuid == rhs.uuid
//    }
//    
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(uuid)
//    }
//}
//
//
//struct UsersByRequest:Codable, Hashable{
//    let username: String
//    let links: linksOfUserForRequest
//}
//
//
//struct linksOfUserForRequest: Codable, Hashable{
//    let html: String
//}
//
//
//struct URLS: Codable, Hashable{
//    let thumb: String
//    let small: String
//}
