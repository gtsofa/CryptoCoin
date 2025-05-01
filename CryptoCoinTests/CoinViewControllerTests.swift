//
//  CoinViewControllerTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 02/05/2025.
//

import XCTest

final class CoinViewController: UIViewController {
    
    private var loader: CoinViewControllerTests.LoaderSpy?
    
    convenience init(loader: CoinViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load()
    }
}

final class CoinViewControllerTests: XCTestCase {
    func test_init_doesNotLoadCoin() {
        let loader = LoaderSpy()
        
        _ = CoinViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsCoin() {
        let loader = LoaderSpy()
        let sut = CoinViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: Helpers
    
    class LoaderSpy {
        var loadCallCount = 0
        
        func load() {
            loadCallCount += 1
        }
    }

}
