//
//  SearchResponse.swift
//  Stocks
//
//  Created by Shivam Rishi on 08/03/22.
//

import Foundation

struct SearchResponse:Codable {
    let count:Int
    let result:[SearchResult]
}

struct SearchResult:Codable {
    let description:String
    let displaySymbol:String
    let symbol:String
    let type:String
}
