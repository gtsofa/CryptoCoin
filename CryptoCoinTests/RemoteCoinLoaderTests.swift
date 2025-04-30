//
//  RemoteCoinLoaderTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 30/04/2025.
//

import XCTest

class HTTPClient {
    static var shared = HTTPClient()
    
    private init() {}
    
    var requestedURL: URL?
}

class RemoteCoinLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")!
    }
}


final class RemoteCoinLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteCoinLoader()
        
        XCTAssertNil(client.requestedURL)
        
    }
    
    func test_load_requestsDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteCoinLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
