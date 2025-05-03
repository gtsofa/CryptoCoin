//
//  CryptoCoinViewModel.swift
//  Prototype
//
//  Created by Julius on 03/05/2025.
//

import Foundation

struct CryptoCoinViewModel: Codable {
    let name: String
    let iconName: String
    let price: Double
    let dayPerformance: Double
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case iconName = "iconUrl"
        case price
        case dayPerformance = "change"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.iconName = try container.decode(String.self, forKey: .iconName)
        
        let priceString = try container.decode(String.self, forKey: .price)
        self.price = Double(priceString) ?? 0.0
        
        let changeString = try container.decode(String.self, forKey: .dayPerformance)
        self.dayPerformance = Double(changeString) ?? 0.0
    }
}


