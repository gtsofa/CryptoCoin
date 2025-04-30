//
//  RemoteCoinLoaderTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 30/04/2025.
//

import XCTest

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteCoinLoader {
    private let client: HTTPClient
    private let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}


final class RemoteCoinLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://-another-url.com")!

        _ = RemoteCoinLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
        
    }
    
    func test_load_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-given-url.com")!
        
        let sut = RemoteCoinLoader(url: url, client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
