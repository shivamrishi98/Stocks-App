//
//  APIManager.swift
//  Stocks
//
//  Created by Shivam Rishi on 07/03/22.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    private struct Constants {
        static let apiKey = "c8jj9baad3i97d61a180"
        static let sandboxApiKey = "sandbox_c8jj9baad3i97d61a18g"
        static let baseUrl = "https://finnhub.io/api/v1/"
    }
    
    
    // MARK: - PUBLIC
    
    public func search(
        query:String,
        completion: @escaping (Result<SearchResponse,Error>) -> Void
    ) {
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        request(
            url: url(
                for: .search,
                queryParams: ["q":safeQuery]),
            expecting: SearchResponse.self,
            completion: completion
        )
    }
    
    
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
        var urlString = Constants.baseUrl + endpoint.rawValue
        
        var queryItems = [URLQueryItem]()
        // Add any parameters
        for (name,value) in queryParams {
            queryItems.append(.init(name: name, value: value))
        }
        // Add token
        queryItems.append(.init(name: "token", value: Constants.apiKey))
        
        // Convert query items to suffix string
        urlString += "?" + queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        
        print("\n\(urlString)\n")
        
        return URL(string: urlString)
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
