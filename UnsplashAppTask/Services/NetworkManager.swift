//
//  NetworkManager.swift
//  UnsplashAppTask
//
//  Created by user on 12.10.23.
//

import Alamofire
import UIKit

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
