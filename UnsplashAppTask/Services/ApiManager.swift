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

final class APIManager {

    static let shared = APIManager()
    private let baseURL = "https://api.unsplash.com/"
    private let clientId = Constant.keyAPI

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension APIManager: APIManagerProtocol {
    // MARK: - Get Images By Request
    func getImagesByRequest(for searchRequest: String, page: Int, completed: @escaping (Result<APIResponse, ErrorMessages>) -> Void) {
        let endpoint = baseURL+"search/photos?query=\(searchRequest)&client_id=\(clientId)&page=\(page)&per_page=30"

        guard let url = URL(string: endpoint) else {
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
        let endpoint = baseURL+"photos/random?client_id=\(clientId)&count=30"

        guard let url = URL(string: endpoint) else {
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

        let endpoint = baseURL+"/photos/\(id)?client_id=\(clientId)"

        guard let url = URL(string: endpoint) else {
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
