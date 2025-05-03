//
//  FavoritesViewController.swift
//  Prototype
//
//  Created by Julius on 03/05/2025.
//

import UIKit

class FavoritesViewController: UITableViewController {
    private var favoriteCoins = [CryptoCoinViewModel]()
    private var coins = [CryptoCoinViewModel]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredCoins = [CryptoCoinViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: "CryptoCoinCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavorites()
        tableView.reloadData()
    }
    
    private func fetchFavorites() {
        CoinService.shared.fetchCoins { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let allCoins):
                    self.favoriteCoins = self.loadFavoriteCoins(from: allCoins)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch coins: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadFavoriteCoins(from coins: [CryptoCoinViewModel]) -> [CryptoCoinViewModel] {
        guard let favoriteNames = UserDefaults.standard.array(forKey: "favoriteCoinNames") as? [String] else {
            return []
        }
        return coins.filter { favoriteNames.contains($0.name) }.map {
            var coin = $0
            coin.isFavorite = true
            return coin
        }
    }
    
    private func saveFavorites() {
        let favoriteNames = favoriteCoins.map { $0.name }
        UserDefaults.standard.set(favoriteNames, forKey: "favoriteCoinNames")
    }
    
    private func updateFavoritesInStorage() {
        CoinService.shared.fetchCoins { result in
            switch result {
            case .success(let allCoins):
                var updatedCoins = allCoins
                for i in 0..<updatedCoins.count {
                    if self.favoriteCoins.contains(where: { $0.name == updatedCoins[i].name }) {
                        updatedCoins[i].isFavorite = true
                    }
                }
                
                if let data = try? JSONEncoder().encode(updatedCoins) {
                    UserDefaults.standard.set(data, forKey: "favorites")
                }
            case .failure(let error):
                print("Error updating favorites: \(error.localizedDescription)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCoins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCoinCell", for: indexPath) as! CryptoCoinCell
        cell.configure(with: favoriteCoins[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = favoriteCoins[indexPath.row]
        let detailVC = CoinDetailViewController()
        detailVC.coin = selectedCoin
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfavoriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            self.favoriteCoins.remove(at: indexPath.row)
            self.saveFavorites()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        unfavoriteAction.image = UIImage(systemName: "star.slash.fill")
        unfavoriteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [unfavoriteAction])
    }
}

