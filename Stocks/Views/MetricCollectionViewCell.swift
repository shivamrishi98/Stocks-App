//
//  MetricCollectionViewCell.swift
//  Stocks
//
//  Created by Shivam Rishi on 11/03/22.
//

import UIKit

/// Tableview cell for metric
final class MetricCollectionViewCell: UICollectionViewCell {
    /// Identifier for cell
    static let identifier = "MetricCollectionViewCell"

    /// Metric table cell viewModel
    struct ViewModel {
        let name:String
        let value:String
    }
    
    /// Name label
    private let nameLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    /// Value label
    private let valueLabel:UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubviews(nameLabel,valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.sizeToFit()
        valueLabel.sizeToFit()
        nameLabel.frame = CGRect(x: 3,
                                 y: 0,
                                 width: nameLabel.width,
                                 height: contentView.height)
        valueLabel.frame = CGRect(x: nameLabel.right + 3,
                                 y: 0,
                                 width: valueLabel.width,
                                 height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        valueLabel.text = nil
    }
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    func configure(with viewModel:ViewModel) {
        nameLabel.text = viewModel.name+":"
        valueLabel.text = viewModel.value
    }

}
