//
//  StockChartView.swift
//  Stocks
//
//  Created by Shivam Rishi on 10/03/22.
//

import UIKit

class StockChartView: UIView {
    
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    /// Reset the chart view
    func reset() {
        
    }
    
    func configure(with viewModel: ViewModel) {
        
    }
    
}