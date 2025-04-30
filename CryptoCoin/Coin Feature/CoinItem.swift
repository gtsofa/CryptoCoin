//
//  CoinItem.swift
//  CryptoCoin
//
//  Created by Julius on 30/04/2025.
//

import Foundation

public struct CoinItem: Equatable {
    let uuid: UUID
    let symbol: String
    let name: String
    let iconURL: URL
    let price: Double
    let change: Double
}
