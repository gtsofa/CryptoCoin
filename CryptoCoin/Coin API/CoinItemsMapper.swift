//
//  CoinItemsMapper.swift
//  CryptoCoin
//
//  Created by Julius on 01/05/2025.
//

import Foundation

final class CoinItemsMapper {
    private struct Root: Decodable {
        let coins: [Item]
        
        var coin: [CoinItem] {
            return coins.map { $0.coin }
        }
    }
    
    private struct Item: Decodable {
        let uuid: UUID
        let symbol: String
        let name: String
        let iconUrl: URL
        let price: Double
        let change: Double
        
        var coin: CoinItem {
            return CoinItem(id: uuid, symbol: symbol, name: name, iconURL: iconUrl, price: price, dayPerformance: change)
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> CoinLoader.Result {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteCoinLoader.Error.invalidData)
        }
        
        return .success(root.coin)
    }
}
