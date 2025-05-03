//
//  CoinService.swift
//  Prototype
//
//  Created by Julius on 03/05/2025.
//

import Foundation

class CoinService {
    static let shared = CoinService()
    private init() {}

    private let urlString = "https://api.coinranking.com/v2/coins"
    
    func fetchCoins(completion: @escaping (Result<[CryptoCoinViewModel], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Optional: If the API requires a key
        // request.setValue("your-api-key", forHTTPHeaderField: "x-access-token")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CoinResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.data.coins))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
