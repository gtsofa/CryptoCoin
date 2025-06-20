//
//  CryptoCoinCell.swift
//  Prototype
//
//  Created by Julius on 03/05/2025.
//

import UIKit

class CryptoCoinCell: UITableViewCell {
    public let symbolLabel = UILabel()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        label.text = "Name"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.text = "Price"
        label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dayPerformanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Performance"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var iconImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit // Changed to scaleAspectFit for better image scaling
        iv.clipsToBounds = true
        return iv
    }()
    
    var favoriteIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemYellow
        return iv
    }()
    
    //let favoriteIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
         // Add containerView to contentView
         contentView.addSubview(containerView)
         
         // Add iconImage to containerView
         containerView.addSubview(iconImage)
         
         // Add other labels to contentView (or containerView if desired)
         contentView.addSubview(symbolLabel)
         contentView.addSubview(nameLabel)
         contentView.addSubview(priceLabel)
         contentView.addSubview(dayPerformanceLabel)
        contentView.addSubview(favoriteIcon)
         
         // Set constraints for containerView
         NSLayoutConstraint.activate([
         containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
         containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
         containerView.widthAnchor.constraint(equalToConstant: 60),
         containerView.heightAnchor.constraint(equalToConstant: 60)
         ])
         
         // Set constraints for iconImage inside containerView
         NSLayoutConstraint.activate([
         iconImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
         iconImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
         iconImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
         iconImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
         ])
         
         // Example constraints for other labels (adjust as needed)
         NSLayoutConstraint.activate([
         symbolLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
         symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
         
         nameLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
         nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
         
         priceLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
         priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
         
         dayPerformanceLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
         dayPerformanceLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
         dayPerformanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
         
         favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
         favoriteIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Basic layout (simplified for brevity)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        dayPerformanceLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconImage)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dayPerformanceLabel)
        contentView.addSubview(favoriteIcon)
        
        // Configure favorite icon
        favoriteIcon.contentMode = .scaleAspectFit
        favoriteIcon.tintColor = .systemYellow
        
        // Layout constraints (simplified)
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 30),
            iconImage.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 20),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 20),
            
            priceLabel.trailingAnchor.constraint(equalTo: favoriteIcon.leadingAnchor, constant: -8),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dayPerformanceLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            dayPerformanceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
