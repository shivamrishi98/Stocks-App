//
//  SearchResultsViewController.swift
//  Stocks
//
//  Created by Shivam Rishi on 07/03/22.
//

import UIKit

protocol SearchResultsViewControllerDelegate:AnyObject {
    func searchResultsViewControllerDidSelect(searchResult:String)
}

class SearchResultsViewController: UIViewController {

    weak var delegate:SearchResultsViewControllerDelegate?
    
    private var results:[String] = []
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        // Register a cell
        tableView.register(SearchResultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func update(with results:[String]) {
        self.results = results
        tableView.reloadData()
    }

}

extension SearchResultsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier,
                                                       for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "AAPL"
        cell.detailTextLabel?.text = "Apple Inc."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsViewControllerDidSelect(searchResult: "AAPL")
    }
}
