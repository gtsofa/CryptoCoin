//
//  RemoteCoinLoaderTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 30/04/2025.
//

import XCTest

class HTTPClient {
    static var shared = HTTPClient()
    
    func get(from url: URL) {}
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    override func get(from url: URL) {
        requestedURL = url
    }
}

class RemoteCoinLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}


final class RemoteCoinLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        
        _ = RemoteCoinLoader()
        
        XCTAssertNil(client.requestedURL)
        
    }
    
    func test_load_requestsDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        
        let sut = RemoteCoinLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
