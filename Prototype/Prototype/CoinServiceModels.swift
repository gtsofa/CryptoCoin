//
//  CoinServiceModels.swift
//  Prototype
//
//  Created by Julius on 03/05/2025.
//

import Foundation

struct CoinResponse: Decodable {
    let data: CoinData
}

struct CoinData: Decodable {
    let coins: [CryptoCoinViewModel]
}
