//
//  FavoritesViewController.swift
//  Prototype
//
//  Created by Julius on 03/05/2025.
//

import UIKit

class FavoritesViewController: UITableViewController {
    private var favoriteCoins = [CryptoCoinViewModel]()
    
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
}

