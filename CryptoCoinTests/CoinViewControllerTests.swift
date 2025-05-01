//
//  CoinViewControllerTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 02/05/2025.
//

import XCTest

final class CoinViewController {
    init(loader: CoinViewControllerTests.LoaderSpy) {}
}

final class CoinViewControllerTests: XCTestCase {
    func test_init_doesNotLoadCoin() {
        let loader = LoaderSpy()
        
        _ = CoinViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: Helpers
    
    class LoaderSpy {
        var loadCallCount = 0
    }

}
