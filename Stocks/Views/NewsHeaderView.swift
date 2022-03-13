//
//  NewsHeaderView.swift
//  Stocks
//
//  Created by Shivam Rishi on 09/03/22.
//

import UIKit

/// Delegate to notify of header events
protocol NewsHeaderViewDelegate: AnyObject {
    /// Notify user tapped header button
    /// - Parameter headerView: Ref of header view
    func newsHeaderViewDidTapAddButton(_ headerView: NewsHeaderView)
}

/// Tableview header for news
final class NewsHeaderView: UITableViewHeaderFooterView {
    /// Header Identifier
    static let identifier = "NewsHeaderView"
    
    /// Ideal height of header
    static let preferredHeight: CGFloat = 70
    
    /// Delegate instance for events
    weak var delegate:NewsHeaderViewDelegate?
    
    /// ViewModel for header view
    struct ViewModel {
        let title:String
        let shouldShowAddButton:Bool
    }
    
    // MARK: - PRIVATE
    
    private let label:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
     let button:UIButton = {
        let button = UIButton()
        button.setTitle("+ Watchlist", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - INIT
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(label, button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 14, y: 0, width: contentView.width-28, height: contentView.height)
        
        button.sizeToFit()
        button.frame = CGRect(x: contentView.width-button.width-16,
                              y: (contentView.height-button.height)/2,
                              width: button.width + 8,
                              height: button.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    /// Handle button tap
    @objc private func didTapButton() {
        delegate?.newsHeaderViewDidTapAddButton(self)
    }
    
    /// Configure view
    /// - Parameter viewModel: View ViewModel
    public func configure(with viewModel: ViewModel) {
        label.text = viewModel.title
        button.isHidden = !viewModel.shouldShowAddButton
    }
}
