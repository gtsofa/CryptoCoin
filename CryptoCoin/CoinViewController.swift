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
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
