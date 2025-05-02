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
        
        expect(sut, toCompleteWith: .failure(RemoteCoinLoader.Error.connectivity), when: {
            client.complete(with: clientError)
        })
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(RemoteCoinLoader.Error.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
            
        }
        
        func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
            let (sut, client) = makeSUT()
            
            expect(sut, toCompleteWith: .failure(RemoteCoinLoader.Error.invalidData), when: {
                let invalidJSON = Data("Invalid JSON".utf8)
                client.complete(withStatusCode: 200, data: invalidJSON)
            })
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: UUID(), symbol: "BTC", name: "Bitcoin", iconURL: URL(string: "https://cdn.coin.com/icon")!, price: 94219.4326, dayPerformance: -1.20)
        
        let item2 = makeItem(id: UUID(), symbol: "ETH", name: "Ethereum", iconURL: URL(string: "https://cdn.coin.com/icon")!, price: 2194.21, dayPerformance: +1.20)
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-url.com")!
        var sut: RemoteCoinLoader? = RemoteCoinLoader(url: url, client: client)
        
        var capturedResults = [CoinLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteCoinLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCoinLoader(url: url, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line )
        
        return (sut, client)
        
    }
    
    private func makeItemsJSON(_ coins: [[String: Any]]) -> Data {
        let json = ["coins": coins]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeItem(id: UUID, symbol: String, name: String, iconURL: URL, price: Double, dayPerformance: Double) -> (model: CoinItem, json: [String: Any]) {
        let json: [String: Any] = ["uuid": id.uuidString, "symbol": symbol, "name": name, "iconUrl": iconURL.absoluteString, "price": price, "change": dayPerformance]
        
        let item = CoinItem(id: id, symbol: symbol, name: name, iconURL: iconURL, price: price, dayPerformance: dayPerformance)
        
        return (item, json)
    }
    
    private func expect(_ sut: RemoteCoinLoader, toCompleteWith expectedResult: Result<[CoinItem], RemoteCoinLoader.Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line ) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteCoinLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
            
        }
        
        action()
        
        wait(for: [exp], timeout: 0.1)
    }
    
    /*
     func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: Result<[FeedImage], RemoteFeedLoader.Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
         let exp = expectation(description: "Wait for load completion")

         sut.load { receivedResult in
             switch (receivedResult, expectedResult) {
             case let (.success(receivedItems), .success(expectedItems)):
                 XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

             case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError)):
                 XCTAssertEqual(receivedError, expectedError, file: file, line: line)

             default:
                 XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
             }

             exp.fulfill()
         }

         action()

         waitForExpectations(timeout: 0.1)
     }
     */
    
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
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil )!
            messages[index].completion(.success(data, response))
        }
    }

}
