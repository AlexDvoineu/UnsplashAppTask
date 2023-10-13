//
//  NetworkManager.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import Alamofire
import UIKit

enum HTTPRequstMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}

enum HTTPResponseCode: String, Error {
    case badRequest = "Unfortunately your request didn't find any results!"
    case accessDenied = "Your access is denied!"
    case notFound = "Unfortunately your request didn't find any images!"
    case successfull
    case invalidHTTPRequest = "Something went wrong..."
    case invalidJSONDecoder = "Something went wrond, we are fixing it right now..."

    var responseCode: Int {
        switch self {
        case .successfull: return 200
        case .badRequest: return 400
        case .accessDenied: return 403
        case .notFound: return 404
        case .invalidHTTPRequest: return 406
        case .invalidJSONDecoder: return 407

        }
    }
}

enum RequestType {
    case random
    case search(searchTerms: String)
}

final class NetworkManager {
    func fetchData(
        requestType: RequestType,
        onCompletion: @escaping ((Result<[Image], Error>) -> Void)
    ) {
        guard let url = createURLcomponents(requestType: requestType) else { return }

        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                do {
                    switch requestType {
                    case .random:
                        if let result = try self.randomImageParseJSON(withData: data ?? Data()) {
                            onCompletion(.success(result))
                        }
                    case .search:
                        if let images = try self.searchImageParseJSON(withData: data ?? Data()) {
                            onCompletion(.success(images))
                        }
                    }
                } catch {
                    onCompletion(.failure(error))
                }
            case .failure(let error):
                print(error)
                onCompletion(.failure(error))
            }
        }
    }

    func downloadImage(url: String, completion: @escaping ((UIImage) -> Void)) {
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func createURLcomponents(requestType: RequestType) -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        switch requestType {
        case .random:
            urlComponents.path = "/photos/random/"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constant.keyAPI),
                URLQueryItem(name: "count", value: "12")
            ]
//        case .random:
//            urlComponents.path = "/search/photos/"
//            urlComponents.queryItems = [
//                URLQueryItem(name: "page", value: "1"),
//                URLQueryItem(name: "per_page", value: "30"),
//                URLQueryItem(name: "client_id", value: Constant.keyAPI),
//                URLQueryItem(name: "query", value: "curated")
//            ]
        case .search(let searchTerms):
            urlComponents.path = "/search/photos/"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constant.keyAPI),
                URLQueryItem(name: "query", value: searchTerms)
            ]
        }
        return urlComponents.url
    }

    private func randomImageParseJSON(withData data: Data) throws -> [Image]? {
        let decoder = JSONDecoder()
        let imageData = try decoder.decode([ImageData].self, from: data)
        var images: [Image] = []
        for datum in imageData {
            guard let image = Image(imageData: datum) else { return nil }
            images.append(image)
        }
        return images
    }

    private func searchImageParseJSON(withData data: Data) throws -> [Image]? {
        let decoder = JSONDecoder()
        let imageData = try decoder.decode(SearchData.self, from: data)
        var images: [Image] = []
        guard let searchData = imageData.results else { return nil }
        for datum in searchData {
            guard let image = Image(searchData: datum) else { return nil }
            images.append(image)
        }
        return images
    }
}

struct UnsplashSectionedImages: Codable, Hashable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashImage]
}

struct UnsplashImage: Codable, Hashable {
    let id: String
    let urls: UnsplashImageURL
    static func == (lhs: UnsplashImage, rhs: UnsplashImage) -> Bool {
        lhs.id == rhs.id && lhs.urls == rhs.urls
    }
}

struct UnsplashImageURL: Codable, Hashable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let small_s3: String
}
