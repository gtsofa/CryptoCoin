//
//  CoinDetailViewController.swift
//  Prototype
//
//  Created by Julius on 03/05/2025.
//

import UIKit

class CoinDetailViewController: UIViewController {
    var coin: CryptoCoinViewModel!

    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let performanceLabel = UILabel()
    private let chartView = UIView() // Placeholder for a chart

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = coin.name

        setupViews()
        configure()
    }

    private func setupViews() {
        nameLabel.font = .boldSystemFont(ofSize: 24)
        priceLabel.font = .systemFont(ofSize: 20)
        performanceLabel.font = .systemFont(ofSize: 20)
        chartView.backgroundColor = .secondarySystemFill
        chartView.layer.cornerRadius = 10

        let stack = UIStackView(arrangedSubviews: [nameLabel, priceLabel, performanceLabel, chartView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func configure() {
        nameLabel.text = coin.name
        priceLabel.text = String(format: "Price: $%.2f", coin.price)
        performanceLabel.text = String(format: "Daily Change: %.2f%%", coin.dayPerformance)
    }
}

