//
//  CoinLoader.swift
//  CryptoCoin
//
//  Created by Julius on 30/04/2025.
//

import Foundation

enum LoadCoinResult {
    case success([CoinItem])
    case failure(Error)
}

protocol CoinLoader {
    func load(completion: @escaping (LoadCoinResult) -> Void)
}
