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
        loadFavorites()
        tableView.reloadData()
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites") {
            let decoder = JSONDecoder()
            if let savedCoins = try? decoder.decode([CryptoCoinViewModel].self, from: data) {
                favoriteCoins = savedCoins.filter { $0.isFavorite }
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
        _  = favoriteCoins[indexPath.row]
        
        let unfavoriteAction = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] (action, view, completion) in
            guard let self = self else { return }
        
            self.favoriteCoins[indexPath.row].isFavorite = false
            self.updateFavoritesInStorage()
            self.favoriteCoins.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        unfavoriteAction.image = UIImage(systemName: "star.slash.fill")
        unfavoriteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [unfavoriteAction])
    }
    
    private func updateFavoritesInStorage() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           var allCoins = try? JSONDecoder().decode([CryptoCoinViewModel].self, from: data) {
            for i in 0..<allCoins.count {
                if let updated = favoriteCoins.first(where: { $0.name == allCoins[i].name }) {
                    allCoins[i].isFavorite = updated.isFavorite
                } else {
                    allCoins[i].isFavorite = false
                }
            }
            
            if let updatedData = try? JSONEncoder().encode(allCoins) {
                UserDefaults.standard.set(updatedData, forKey: "favorites")
            }
        }
    }
}

