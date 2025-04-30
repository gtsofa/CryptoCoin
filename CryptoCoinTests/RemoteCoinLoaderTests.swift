//
//  RemoteCoinLoaderTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 30/04/2025.
//

import XCTest
import CryptoCoin

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}


final class RemoteCoinLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
        
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteCoinLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCoinLoader(url: url, client: client)
        return (sut, client)
        
    }

}
