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
    
    public func load(completion: @escaping (CoinLoader.Result) -> Void = { _ in }) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(CoinItemsMapper.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
                
            }
            
        }
    }
}
