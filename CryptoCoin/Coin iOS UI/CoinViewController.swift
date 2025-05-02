//
//  CoinViewController.swift
//  CryptoCoin
//
//  Created by Julius on 02/05/2025.
//

import UIKit

public final class CoinViewController: UITableViewController {
    
    private var loader: CoinLoader?
    public private(set) var isViewAppeared = false
    private var onViewIsAppearing: ((CoinViewController) -> Void)?
    
    private var tableModel = [CoinItem]()
    
    public convenience init(loader: CoinLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewIsAppearing = { vc in
            vc.onViewIsAppearing = nil
            vc.load()
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            switch result {
            case let .success(coin):
                self?.tableModel = coin
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
                
            case .failure:
                break
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CryptoCoinCell()
        let cellModel = tableModel[indexPath.row]
        cell.symbolLabel.text = cellModel.symbol
        cell.nameLabel.text = cellModel.name
        cell.priceLabel.text = "\(cellModel.price)"
        cell.dayPerformanceLabel.text = "\(cellModel.dayPerformance)"
        
        return cell
    }
}
