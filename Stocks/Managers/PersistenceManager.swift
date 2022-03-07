//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Shivam Rishi on 07/03/22.
//

import Foundation

final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults:UserDefaults = .standard
    
    private struct Constants {
        
    }
    
    private init() {}
    
    // MARK: - PUBLIC
    
    public var watchlist:[String] {
        return  []
    }
    
    public func addToWatchlist() {
        
    }
    
    public func removeFromWatchlist() {
        
    }
    
    
    // MARK: - PRIVATE
    
    private var hasOnboarded: Bool {
        return false
    }
}
