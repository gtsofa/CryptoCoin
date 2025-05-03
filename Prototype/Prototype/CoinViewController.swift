//
//  CoinViewController.swift
//  Prototype
//
//  Created by Julius on 02/05/2025.
//

import UIKit

class CoinViewController: UITableViewController {
    private var coins = [CryptoCoinViewModel]()
    // Search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredCoins = [CryptoCoinViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Coins"
        setupRefreshControl()
        
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: "CryptoCoinCell")
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        
        configureSearchController()
        
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if coins.isEmpty {
            showRefreshManually()
        }
    }
    
    private func fetchData() {
        CoinService.shared.fetchCoins { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let coins):
                    self.coins = coins
                    self.loadFavorites()
                    self.filteredCoins = self.coins
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching coins: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showRefreshManually() {
        guard let refreshControl = self.refreshControl else { return }
        
        tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        refreshControl.beginRefreshing()
        
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
        
        CoinService.shared.fetchCoins { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let coins):
                    self.coins = coins
                    self.filteredCoins = coins
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error refreshing coins: \(error.localizedDescription)")
                }
                self.refreshControl?.endRefreshing()
            }
        }
    }

    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by price or performance"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["Price", "Performance"]
        searchController.searchBar.delegate = self
        
        // Initialize filtered items
        filteredCoins = coins
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredCoins.count : coins.count //coins.count //10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCoinCell", for: indexPath) as! CryptoCoinCell
        let model = searchController.isActive ? filteredCoins[indexPath.row] : coins[indexPath.row] //coins[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    // MARK: - Swipe actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = coins[indexPath.row]
        
        let favoriteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else { return }
            // Toggle favorite status
            self.coins[indexPath.row].isFavorite.toggle()
            // Reload the cell to update the favorite icon
            tableView.reloadRows(at: [indexPath], with: .automatic)
            self.saveFavorites()
            completion(true)
        }
        
        favoriteAction.image = UIImage(systemName: coin.isFavorite ? "star.slash.fill" : "star.fill")
        favoriteAction.backgroundColor = .systemYellow
        favoriteAction.title = coin.isFavorite ? "Unfavorite" : "Favorite"
        
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = searchController.isActive ? filteredCoins[indexPath.row] : coins[indexPath.row]
        let detailVC = CoinDetailViewController()
        detailVC.coin = selectedCoin
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension CryptoCoinCell {
    func configure(with model: CryptoCoinViewModel) {
        nameLabel.text = model.name
        iconImage.image = UIImage(named: model.iconName)
        priceLabel.text = String(format: "%.2f", model.price)
        dayPerformanceLabel.text = String(format: "%.2f", model.dayPerformance)
        favoriteIcon.image = model.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
    }
}

extension CoinViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredCoins = coins
            tableView.reloadData()
            return
        }
        
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        filterContent(for: searchText, scope: selectedScope)
        tableView.reloadData()
    }
    
    func filterContent(for searchText: String, scope: Int) {
        filteredCoins = coins.filter { item in
            if scope == 0 { // Price
                let priceString = String(format: "%.2f", item.price)
                return priceString.lowercased().contains(searchText.lowercased())
            } else { // Performance
                let performanceString = String(format: "%.2f", item.dayPerformance)
                return performanceString.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    // Handle scope button changes
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            filteredCoins = coins
            tableView.reloadData()
            return
        }
        filterContent(for: searchText, scope: selectedScope)
        tableView.reloadData()
    }
    
    // MARK: - Persistenc
    
    private func saveFavorites() {
        let favoriteNames = coins.filter { $0.isFavorite }.map { $0.name }
        UserDefaults.standard.set(favoriteNames, forKey: "favoriteCoinNames")
    }

    private func loadFavorites() {
        if let favoriteNames = UserDefaults.standard.array(forKey: "favoriteCoinNames") as? [String] {
            for i in 0..<coins.count {
                coins[i].isFavorite = favoriteNames.contains(coins[i].name)
            }
        }
    }

}
