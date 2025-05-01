//
//  RemoteCoinLoaderTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 30/04/2025.
//

import XCTest
import CryptoCoin

final class RemoteCoinLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
        
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let clientError = NSError(domain: "test", code: 0)
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            client.complete(with: clientError)
        })
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, at: index)
            })
            
        }
        
        func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
            let (sut, client) = makeSUT()
            
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let invalidJSON = Data("Invalid JSON".utf8)
                client.complete(withStatusCode: 200, data: invalidJSON)
            })
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSON() {
        let (sut, client) = makeSUT()
        
        var capturedResults = [RemoteCoinLoader.Result]()
        sut.load { capturedResults.append($0)}
        
        
        let emptyListJSON = Data("{\"coins\": []}".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)
        
        XCTAssertEqual(capturedResults, [.success([])])
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = CoinItem(id: UUID(), symbol: "BTC", name: "Bitcoin", iconURL: URL(string: "https://cdn.coin.com/icon")!, price: 94219.4326, dayPerformance: -1.20)
        
        let item2 = CoinItem(id: UUID(), symbol: "ETH", name: "Ethereum", iconURL: URL(string: "https://cdn.coin.com/icon")!, price: 2194.21, dayPerformance: +1.20)
       
        let item1JSON: [String: Any] = ["uuid": item1.id.uuidString, "symbol": item1.symbol, "name": item1.name, "iconUrl": item1.iconURL.absoluteString, "price": item1.price, "change": item1.dayPerformance]
        
        let item2JSON: [String: Any] = ["uuid": item2.id.uuidString, "symbol": item2.symbol, "name": item2.name, "iconUrl": item2.iconURL.absoluteString, "price": item2.price, "change": item2.dayPerformance]
        
        let itemsJSON = ["coins": [item1JSON, item2JSON]]
        
        expect(sut, toCompleteWith: .success([item1, item2]), when: {
            let json = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteCoinLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCoinLoader(url: url, client: client)
        return (sut, client)
        
    }
    
    private func expect(_ sut: RemoteCoinLoader, toCompleteWith result: RemoteCoinLoader.Result, when action: () -> Void ) {
        var capturedResults = [RemoteCoinLoader.Result]()
        sut.load { capturedResults.append($0)}
        
        action()
        
        XCTAssertEqual(capturedResults, [result])
    }
    
    private class HTTPClientSpy: HTTPClient {

        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url}
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil )!
            messages[index].completion(.success(data, response))
        }
    }

}
