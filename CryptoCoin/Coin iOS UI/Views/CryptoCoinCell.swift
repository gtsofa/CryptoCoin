//
//  CryptoCoinCell.swift
//  CryptoCoin
//
//  Created by Julius on 02/05/2025.
//

import UIKit

public final class CryptoCoinCell: UITableViewCell {
    public let symbolLabel = UILabel()
    //public let nameLabel = UILabel()
    //public let priceLabel = UILabel()
    //public let dayPerformanceLabel = UILabel()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dayPerformanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var iconImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(iconImage)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(dayPerformanceLabel)
        self.contentView.addSubview(containerView)
        iconImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        iconImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.iconImage.trailingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        nameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
        
        dayPerformanceLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 30).isActive = true
        dayPerformanceLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
