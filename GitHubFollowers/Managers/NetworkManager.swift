//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/21/24.
//

import UIKit

class NetworkManager {
    static let shared   = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache           = NSCache<NSString, UIImage>()
    let decoder         = JSONDecoder()

    private init() {
        decoder.keyDecodingStrategy     = .convertFromSnakeCase
        decoder.dateDecodingStrategy    = .iso8601
    }
    
//    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[FollowerModel], ErrorMessage>) -> Void) {
//        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
//        
//        guard let url = URL(string: endpoint) else {
//            completed(.failure(.invalidUsername))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            
//            if let _ = error {
//                completed(.failure(.unableToComplete))
//                return
//            }
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//            
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([FollowerModel].self, from: data)
//                completed(.success(followers))
//            } catch {
//                completed(.failure(.invalidData))
//            }
//        }
//        
//        task.resume()
//    }
    
    func getFollowers(for username: String, page: Int) async throws -> [FollowerModel] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw ErrorMessage.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorMessage.invalidResponse
        }
        
        do {
            return try decoder.decode([FollowerModel].self, from: data)
        } catch {
            throw ErrorMessage.invalidData
        }
    }
    
    func getUserInfo(for username: String) async throws -> UserModel {
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            throw ErrorMessage.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ErrorMessage.invalidResponse
        }
        
        do {
            return try decoder.decode(UserModel.self, from: data)
        } catch {
            throw ErrorMessage.invalidData
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else {
                return nil
            }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
