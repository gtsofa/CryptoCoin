//
//  CoinViewController.swift
//  Prototype
//
//  Created by Julius on 02/05/2025.
//

import UIKit

class CoinViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CryptoCoinCell.self, forCellReuseIdentifier: "CryptoCoinCell")
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCoinCell", for: indexPath) as! CryptoCoinCell
        cell.symbolLabel.text = "BTC"
        cell.nameLabel.text = "Bitcoin"
        cell.priceLabel.text = "$50,000"
        cell.dayPerformanceLabel.text = "-5.34"
        //cell.iconImage.image = UIImage(named: "bitcoinIcon") // Set your image
        return cell
    }
}
