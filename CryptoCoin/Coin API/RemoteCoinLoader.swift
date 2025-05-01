//
//  RemoteCoinLoader.swift
//  CryptoCoin
//
//  Created by Julius on 30/04/2025.
//

import Foundation

public class RemoteCoinLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([CoinItem])
        case failure(Error)
    }
    
    public func load(completion: @escaping (Result) -> Void = { _ in }) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                do {
                    let coins = try FeedItemsMapper.map(data, response)
                    completion(.success(coins))
                } catch {
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.connectivity))
                
            }
            
        }
    }
}

private class FeedItemsMapper {
    private struct Root: Decodable {
        let coins: [Item]
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
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [CoinItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteCoinLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.coins.map { $0.coin }
    }
}
