//
//  NetworkManager.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 13.10.23.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.unsplash.com/"
    // private let clientId = Constant.keyAPI
    // Another key if rate limit exceeded
    // CewI7tFKhXqMgfDQ_mWQc2KYRxQLsXyTv033_CvAIko
    // mXn3boZyLcKIvK-0rIdaoIgiJ4fYoDanWHhheM5EQnc
    private let clientId = "CewI7tFKhXqMgfDQ_mWQc2KYRxQLsXyTv033_CvAIko"
    
    private init() {}
    
    //MARK: - Get Images By Request
    func getImagesByRequest(for searchRequest: String, page: Int, completed: @escaping (Result<APIResponse, ErrorMessages>) -> Void) {
        let endpoint = baseURL+"search/photos?query=\(searchRequest)&client_id=\(clientId)&page=\(page)&per_page=30"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
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
    
    //MARK: - Get Random Images
    func getRandomImages(completed: @escaping (Result<[RandomImagesResult], ErrorMessages>) -> Void) {
        let endpoint = baseURL+"photos/random?client_id=\(clientId)&count=30"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let randomTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
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
                let resultsRandomImages      = try decoder.decode([RandomImagesResult].self, from: data)
                completed(.success(resultsRandomImages))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        randomTask.resume()
    }
    
    
    //MARK: - Get Images By Id
    func getImagesByID(for id: String, completed: @escaping (Result<ImageResult, ErrorMessages>) -> Void) {
        
        let endpoint = baseURL+"/photos/\(id)?client_id=\(clientId)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
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
    
//    func downloadImage(from urlString: String, completed: @escaping(UIImage?)-> Void){
//        let cacheKey = NSString(string: urlString)
//
//        if let image = cache.object(forKey: cacheKey) {
//            completed(image)
//            return
//        }
//        
//        guard let url = URL(string: urlString) else {
//            completed(nil)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            
//            guard let self = self,
//                  error == nil,
//                  let response = response as? HTTPURLResponse, response.statusCode == 200,
//                  let data = data,
//                  let image = UIImage(data: data) else {
//                completed(nil)
//                return
//            }
//            self.cache.setObject(image, forKey: cacheKey)
//            completed(image)
//        }
//        task.resume()
//    }
}
