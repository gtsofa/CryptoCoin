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
    private var coins = [CryptoCoinViewModel]()
    // Search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Coins"
        setupRefreshControl()
        
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: "CryptoCoinCell")
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if coins.isEmpty {
            showRefreshManually()
        }
    }
    
    private func showRefreshManually() {
        guard let refreshControl = self.refreshControl else { return }
        
        // Manually show the spinner
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
        
        // Trigger your data loading logic
        refresh()
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
    }
    
    @objc func refresh() {
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.coins.isEmpty {
                self.coins = CryptoCoinViewModel.prototypeData
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
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
        return coins.count //10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCoinCell", for: indexPath) as! CryptoCoinCell
        let model = coins[indexPath.row]
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
