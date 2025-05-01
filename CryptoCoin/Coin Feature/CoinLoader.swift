//
//  CoinLoader.swift
//  CryptoCoin
//
//  Created by Julius on 30/04/2025.
//

import Foundation

public protocol CoinLoader {
    typealias Result = Swift.Result<[CoinItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
