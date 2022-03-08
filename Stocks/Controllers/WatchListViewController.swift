//
//  ViewController.swift
//  Stocks
//
//  Created by Shivam Rishi on 07/03/22.
//

import UIKit

class WatchListViewController: UIViewController {

    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setUpTitleView()
        
    }
    
    // MARK: - PRIVATE
    
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
        
        // Optimize to reduce number of searches for when user stops typing
        
        // Call API to search
        
        // Update results controller
        resultsVC.update(with: ["GOOG"])
    }
}

extension WatchListViewController:SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidSelect(searchResult: String) {
        // Present stock details for given stock selection
    }
}
