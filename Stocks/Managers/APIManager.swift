//
//  APIManager.swift
//  Stocks
//
//  Created by Shivam Rishi on 07/03/22.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private struct Constants {
        static let apiKey = ""
        static let sandboxApiKey = ""
        static let baseUrl = ""
    }
    
    
    private init() {}
    
    // MARK: - PUBLIC
    
    // get stock info
    
    // search stocks
    
    // MARK: - PRIVATE
    
    private enum Endpoint: String {
        case search
    }
    
    private enum APIError:Error {
        case noDataReturned
        case invalidUrl
    }
    
    private func url(for endpoint: Endpoint,
                     queryParams:[String:String] = [:]
    ) -> URL? {
        
        return nil
    }
    
    private func request<T:Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T,Error>) -> Void
    ) {
        guard let url = url else {
            // Invalid url
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(APIError.noDataReturned))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
}
