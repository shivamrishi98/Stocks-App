//
//  ViewController.swift
//  Stocks
//
//  Created by Shivam Rishi on 07/03/22.
//

import UIKit
import FloatingPanel

class WatchListViewController: UIViewController {

    private var searchTimer:Timer?
    
    private var panel:FloatingPanelController?
    
    static var maxChangeWidth:CGFloat = 0
    
    /// Model
    private var watchlistMap:[String: [CandleStick]] = [:]
    
    /// ViewModels
    private var viewModels: [WatchListTableViewCell.ViewModel] = []
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(WatchListTableViewCell.self,
                           forCellReuseIdentifier: WatchListTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setUpTableView()
        fetchWatchlistData()
        setUpFloatingPanel()
        setUpTitleView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - PRIVATE
    
    private func fetchWatchlistData() {
        let symbols = PersistenceManager.shared.watchlist
        
        let group = DispatchGroup()
        
        for symbol in symbols {
            group.enter()
            APIManager.shared.marketData(for: symbol) { [weak self] result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let response):
                    let candleSticks = response.candleSticks
                    self?.watchlistMap[symbol] = candleSticks
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.createViewModels()
            self?.tableView.reloadData()
        }
    }
    
    private func createViewModels() {
        var viewModels = [WatchListTableViewCell.ViewModel]()
        
        for (symbol, candleSticks) in watchlistMap {
            let changePercentage = getChangePercentage(for: candleSticks)
            viewModels.append(
                .init(symbol: symbol,
                      companyName: UserDefaults.standard.string(forKey: "symbol") ?? "Company",
                      price: getLatestClosingPrice(from: candleSticks),
                      changeColor: changePercentage < 0 ? .systemRed : .systemGreen,
                      changePercentage: .percentage(from: changePercentage),
                      chartViewModel: .init(
                        data: candleSticks.reversed().map { $0.close },
                        showLegend: false,
                        showAxis: false)))
        }
        self.viewModels = viewModels
    }
    
    private func getChangePercentage(for data: [CandleStick]) ->  Double {
        let latestDate = data[0].date
        guard let latestClose = data.first?.close,
              let priorClose = data.first(where: {
                  !Calendar.current.isDate($0.date, inSameDayAs: latestDate)
              })?.close else {
                  return 0.0
        }
        let diff = 1-(priorClose/latestClose)
        return diff
    }

    private func getLatestClosingPrice(from data: [CandleStick]) ->  String {
        guard let closingPrice = data.first?.close else {
            return ""
        }
        return .formatted(number: closingPrice)
    }
        
    private func setUpTableView() {
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpFloatingPanel() {
        let vc = NewsViewController(type: .topStories)
        let panel = FloatingPanelController(delegate: self)
        panel.surfaceView.backgroundColor = .secondarySystemBackground
        panel.set(contentViewController: vc)
        panel.addPanel(toParent: self)
        panel.track(scrollView: vc.tableView)
    }
    
    private func setUpTitleView() {
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: navigationController?.navigationBar.height ?? 100))
        let label = UILabel(frame: CGRect(x: 10,
                                          y: 0,
                                          width: titleView.width-20,
                                          height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        titleView.addSubview(label)
        
        navigationItem.titleView = titleView
    }
    
    private func setupSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }

    
}

extension WatchListViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  return
              }
        
        // Reset timer
        searchTimer?.invalidate()
        
        // Kick off new timer
        // Optimize to reduce number of searches for when user stops typing
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            // Call API to search
            APIManager.shared.search(query: query) { result in
                switch result {
                case .success(let response):
                    // Update results controller
                    DispatchQueue.main.async {
                        resultsVC.update(with: response.result)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        resultsVC.update(with: [])
                    }
                    print(error)
                }
            }
        })
    }
}

extension WatchListViewController:SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: SearchResult) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        // Present stock details for given stock selection
        let vc = StockDetailsViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.title = searchResult.description
        present(navVC, animated: true)
    }
}

extension WatchListViewController:FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListTableViewCell.identifier,
                                                       for: indexPath) as? WatchListTableViewCell else {
            fatalError()
        }
        cell.delegate = self
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchListTableViewCell.preferredHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open details for selection
    }
}

extension WatchListViewController:WatchListTableViewCellDelegate {
    
    func didUpdateMaxWidth() {
        // Optimize: Only refresh rows prior to the current row that changes the max width
        tableView.reloadData()
    }
}
