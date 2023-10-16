//
//  NetworkManager.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

protocol APIManagerProtocol {
    func getImagesByRequest(for searchRequest: String, page: Int, completed: @escaping (Result<APIResponse, ErrorMessages>) -> Void)
    func getRandomImages(page: Int, completed: @escaping (Result<[RandomImagesResult], ErrorMessages>) -> Void)
    func getImagesByID(for id: String, completed: @escaping (Result<ImageResult, ErrorMessages>) -> Void)
}

enum RequestType {
    case random(page: String)
    case search(searchTerms: String)
    case byId(id: String)
}

final class APIManager {

    static let shared = APIManager()
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension APIManager: APIManagerProtocol {
    
    private func createURLcomponents(requestType: RequestType) -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        switch requestType {
        case .random(let page):
            urlComponents.path = "/photos/random/"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constant.keyAPI),
                URLQueryItem(name: "page", value: page),
                URLQueryItem(name: "count", value: Constant.imagesPerPage)
            ]
        case .search(let searchTerms):
            urlComponents.path = "/search/photos/"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constant.keyAPI),
                URLQueryItem(name: "query", value: searchTerms),
                URLQueryItem(name: "per_page", value: Constant.imagesPerPage)
            ]
        case .byId(let id):
            urlComponents.path = "/photos/\(id)/"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constant.keyAPI)
            ]
        }
        return urlComponents.url
        // let endpoint = baseURL+"/photos/\(id)?client_id=\(clientId)"
    }
    
    // MARK: - Get Images By Request
    func getImagesByRequest(for searchRequest: String, page: Int, completed: @escaping (Result<APIResponse, ErrorMessages>) -> Void) {
        
        guard let url = createURLcomponents(requestType: .search(searchTerms: searchRequest)) else {
            completed(.failure(.invalidRequest))
            return
        }

        let task = urlSession.dataTask(with: url) { data, response, error in

            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let resultsImages = try decoder.decode(APIResponse.self, from: data)
                completed(.success(resultsImages))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    // MARK: - Get Random Images
    func getRandomImages(page: Int, completed: @escaping (Result<[RandomImagesResult], ErrorMessages>) -> Void) {

        guard let url = createURLcomponents(requestType: .random(page: String(page))) else {
            completed(.failure(.invalidRequest))
            return
        }

        let randomTask = urlSession.dataTask(with: url) { data, response, error in

            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let resultsRandomImages = try decoder.decode([RandomImagesResult].self, from: data)
                completed(.success(resultsRandomImages))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        randomTask.resume()
    }

    // MARK: - Get Images By Id
    func getImagesByID(for id: String, completed: @escaping (Result<ImageResult, ErrorMessages>) -> Void) {

        guard let url = createURLcomponents(requestType: .byId(id: id)) else {
            completed(.failure(.invalidRequest))
            return
        }

        let task = urlSession.dataTask(with: url) { data, response, error in

            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let resultImage = try decoder.decode(ImageResult.self, from: data)
                completed(.success(resultImage))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
