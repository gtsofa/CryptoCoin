//
//  CoinViewController.swift
//  Prototype
//
//  Created by Julius on 02/05/2025.
//

import UIKit

struct CryptoCoinViewModel {
    public let name: String
    public let iconName: String
    public let price: Double
    public let dayPerformance: Double
}

class CoinViewController: UITableViewController {
    private let coin = CryptoCoinViewModel.prototypeData
    // Search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: "CryptoCoinCell")
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        
        configureSearchController()
    }
    
    func configureSearchController() {
        // Configure search controller
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by price or performance"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Optional: Add scope buttons for filtering by price or performance
        searchController.searchBar.scopeButtonTitles = ["Price", "Performance"]
        //searchController.searchBar.delegate = self
        
        // Initialize filtered items
        //filteredItems = items
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coin.count //10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCoinCell", for: indexPath) as! CryptoCoinCell
        let model = coin[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
}

extension CryptoCoinCell {
    func configure(with model: CryptoCoinViewModel) {
        nameLabel.text = model.name
        iconImage.image = UIImage(named: model.iconName)
        priceLabel.text = String(format: "%.2f", model.price)
        dayPerformanceLabel.text = String(format: "%.2f", model.dayPerformance)
        
    }
}
