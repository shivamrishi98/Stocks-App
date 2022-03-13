//
//  StockDetailHeaderView.swift
//  Stocks
//
//  Created by Shivam Rishi on 11/03/22.
//

import UIKit

/// Header for stock details
final class StockDetailHeaderView: UIView {

    /// Metrics viewModels
    private var metricViewModels:[MetricCollectionViewCell.ViewModel] = []
    
    /// ChartView
    private let chartView = StockChartView()
    
    /// CollectionView
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MetricCollectionViewCell.self,
                                forCellWithReuseIdentifier: MetricCollectionViewCell.identifier)
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
    // MARK: - INIT
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubviews(chartView,collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: width,
                                 height: height-100)
        collectionView.frame = CGRect(x: 0,
                                      y: height-100,
                                      width: width,
                                      height: 100)
    }
    
    /// Configure view
    /// - Parameters:
    ///   - chartViewModel: Chart viewModel
    ///   - metricViewModels: Collection of metric viewModels
    func configure(
        chartViewModel:StockChartView.ViewModel,
        metricViewModels:[MetricCollectionViewCell.ViewModel]
    ) {
        // Update Chart
        chartView.configure(with: chartViewModel)
        
        self.metricViewModels = metricViewModels
        collectionView.reloadData()
    }
    
}

// MARK: - EXTENSION - CollectionView

extension StockDetailHeaderView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return metricViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MetricCollectionViewCell.identifier, for: indexPath) as? MetricCollectionViewCell else {
            fatalError()
        }
        let viewModel = metricViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width/2, height: 100/3)
    }
}
