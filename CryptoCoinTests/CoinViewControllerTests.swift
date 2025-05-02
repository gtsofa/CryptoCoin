//
//  CoinViewControllerTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 02/05/2025.
//

import XCTest
import CryptoCoin

final class CoinViewController: UIViewController {
    
    private var loader: CoinLoader?
    
    convenience init(loader: CoinLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load { _ in }
    }
}

final class CoinViewControllerTests: XCTestCase {
    func test_init_doesNotLoadCoin() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsCoin() {
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
        
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoinViewController, loader: LoaderSpy) {
        let client = LoaderSpy()
        let sut = CoinViewController(loader: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    class LoaderSpy: CoinLoader {
        var loadCallCount = 0
        
        func load(completion: @escaping (CoinLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }

}
