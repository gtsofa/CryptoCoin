//
//  CoinLoader.swift
//  CryptoCoin
//
//  Created by Julius on 30/04/2025.
//

import Foundation

enum Result {
    case success([CoinItem])
    case failure(Error)
}

protocol CoinLoader {
    func load(completion: @escaping (Result) -> Void)
}
