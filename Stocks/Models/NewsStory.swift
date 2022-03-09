//
//  NewsStory.swift
//  Stocks
//
//  Created by Shivam Rishi on 09/03/22.
//

import Foundation

struct NewsStory:Codable {
    let category:String
    let datetime:TimeInterval
    let headline:String
    let image:String
    let related:String
    let source:String
    let summary:String
    let url:String
}
