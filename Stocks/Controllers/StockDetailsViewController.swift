//
//  StockDetailsViewController.swift
//  Stocks
//
//  Created by Shivam Rishi on 07/03/22.
//

import UIKit

class StockDetailsViewController: UIViewController {

    // MARK: - PROPERTIES
    
    private let symbol:String
    private let companyName:String
    private var candleStickData:[CandleStick]
    
    // MARK: - INIT
    
    // Symbol, Company Name, Any chart data we may have
    init(
        symbol: String,
        companyName:String,
        candleStickData: [CandleStick] = []
    ) {
        self.symbol = symbol
        self.companyName = companyName
        self.candleStickData = candleStickData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}
