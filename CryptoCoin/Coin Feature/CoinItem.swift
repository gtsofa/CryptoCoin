//
//  CoinItem.swift
//  CryptoCoin
//
//  Created by Julius on 30/04/2025.
//

import Foundation

public struct CoinItem: Equatable {
    public let id: UUID
    public let symbol: String
    public let name: String
    public let iconURL: URL
    public let price: Double
    public let dayPerformance: Double
    
    public init(id: UUID, symbol: String, name: String, iconURL: URL, price: Double, dayPerformance: Double) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.iconURL = iconURL
        self.price = price
        self.dayPerformance = dayPerformance
    }
}

extension CoinItem: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case symbol
        case name
        case iconURL = "iconUrl"
        case price
        case dayPerformance = "change"
    }
}
