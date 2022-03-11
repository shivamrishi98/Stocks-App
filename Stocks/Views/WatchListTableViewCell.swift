//
//  WatchListTableViewCell.swift
//  Stocks
//
//  Created by Shivam Rishi on 10/03/22.
//

import UIKit

protocol WatchListTableViewCellDelegate: AnyObject {
    func didUpdateMaxWidth()
}

class WatchListTableViewCell: UITableViewCell {
    static let identifier = "WatchListTableViewCell"
    
    weak var delegate:WatchListTableViewCellDelegate?
    
    static let preferredHeight:CGFloat = 60

    
    struct ViewModel {
        let symbol:String
        let companyName:String
        let price: String // formatted
        let changeColor:UIColor // red or green
        let changePercentage:String // formatted
         let chartViewModel: StockChartView.ViewModel
    }
    
    private let symbolLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let companyLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let priceLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    private let changeLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    private let miniChartView:StockChartView = {
        let view = StockChartView()
        view.backgroundColor = .link
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubviews(symbolLabel,
                    companyLabel,
                    miniChartView,
                    priceLabel,
                    changeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        symbolLabel.sizeToFit()
        companyLabel.sizeToFit()
        priceLabel.sizeToFit()
        changeLabel.sizeToFit()
        
        let yStart:CGFloat = (contentView.height-symbolLabel.height-companyLabel.height)/2
        symbolLabel.frame = CGRect(x: separatorInset.left,
                                   y: yStart,
                                   width: symbolLabel.width,
                                   height: symbolLabel.height)
        
        companyLabel.frame = CGRect(x: separatorInset.left,
                                    y: symbolLabel.bottom,
                                    width: companyLabel.width,
                                    height: companyLabel.height)
        
        let currentWidth = max(max(priceLabel.width,changeLabel.width),
                               WatchListViewController.maxChangeWidth)
        
        if currentWidth > WatchListViewController.maxChangeWidth {
            WatchListViewController.maxChangeWidth = currentWidth
            delegate?.didUpdateMaxWidth()
        }
        
        
        priceLabel.frame = CGRect(x: contentView.width-currentWidth-10,
                                  y: (contentView.height-priceLabel.height-changeLabel.height)/2,
                                  width: currentWidth,
                                  height: priceLabel.height)
        
        changeLabel.frame = CGRect(x: contentView.width-currentWidth-10,
                                   y: priceLabel.bottom,
                                   width: currentWidth,
                                   height: changeLabel.height)
        
        miniChartView.frame = CGRect(x: priceLabel.left - (contentView.width/3) - 5,
                                     y: 6,
                                     width: contentView.width/3,
                                     height: contentView.height-12)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
        miniChartView.reset()
    }
    
    public func configure(with viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        companyLabel.text = viewModel.companyName
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.changePercentage
        changeLabel.backgroundColor = viewModel.changeColor
        // Configure chart
    }
    
}