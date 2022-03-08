//
//  SearchResultTableViewCell.swift
//  Stocks
//
//  Created by Shivam Rishi on 08/03/22.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultTableViewCell"
    
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
