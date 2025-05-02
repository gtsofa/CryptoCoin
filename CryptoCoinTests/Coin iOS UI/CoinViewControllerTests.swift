//
//  CoinViewControllerTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 02/05/2025.
//

import XCTest
import CryptoCoin


final class CoinViewControllerTests: XCTestCase {
    func test_loadCoinActions_requestCoinFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
        
        sut.simulateAppearance()
        XCTAssertEqual(loader.loadCallCount, 1)
        
        sut.simulateUserInitiatedCoinReload()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.simulateUserInitiatedCoinReload()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_loadingCoinIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
        
        loader.completeCoinLoading(at: 0)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
        
        sut.simulateUserInitiatedCoinReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
        loader.completeCoinLoading(at: 1)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    func test_loadCompletion_rendersSuccessfullyLoadedCoins() {
        let (sut, loader) = makeSUT()
        let cryptoCoin0 = makeCryptoCoin(symbol: "a symbol", name: "a name", iconURL: URL(string: "https://a-url.com")!, price: 987.65, dayPerformance: -3.47)
        
        let cryptoCoin1 = makeCryptoCoin(symbol: "another symbol", name: "another name", iconURL: URL(string: "https://another-url.com")!, price: 105.65, dayPerformance: -1.47)
        
        
        sut.simulateAppearance()
        XCTAssertEqual(sut.numberOfRenderedCoinViews(), 0)
        
        loader.completeCoinLoading(with: [cryptoCoin0], at: 0)
        XCTAssertEqual(sut.numberOfRenderedCoinViews(), 1)
        
        let view = sut.cryptoCoinView(at: 0) as? CryptoCoinCell
        
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.symbolText, cryptoCoin0.symbol)
        XCTAssertEqual(view?.nameText, cryptoCoin0.name)
        XCTAssertEqual(view?.priceText, String(cryptoCoin0.price))
        XCTAssertEqual(view?.dayPerformanceText, String(cryptoCoin0.dayPerformance))
        
        sut.simulateUserInitiatedCoinReload()
        loader.completeCoinLoading(with: [cryptoCoin0, cryptoCoin1], at: 1)
        XCTAssertEqual(sut.numberOfRenderedCoinViews(), 2)
        
        let view0 = sut.cryptoCoinView(at: 1) as? CryptoCoinCell
        
        XCTAssertNotNil(view0)
        XCTAssertEqual(view0?.symbolText, cryptoCoin1.symbol)
        XCTAssertEqual(view0?.nameText, cryptoCoin1.name)
        XCTAssertEqual(view0?.priceText, String(cryptoCoin1.price))
        XCTAssertEqual(view0?.dayPerformanceText, String(cryptoCoin1.dayPerformance))
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoinViewController, loader: LoaderSpy) {
        let client = LoaderSpy()
        let sut = CoinViewController(loader: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private func makeCryptoCoin(symbol: String, name: String, iconURL: URL, price: Double, dayPerformance: Double) -> CoinItem {
        return CoinItem(id: UUID(), symbol: symbol, name: name, iconURL: iconURL, price: price, dayPerformance: dayPerformance)
    }
    
    class LoaderSpy: CoinLoader {
        var loadCallCount: Int {
            completions.count
        }
        
        var completions = [(CoinLoader.Result) -> Void]()
        
        func load(completion: @escaping (CoinLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeCoinLoading(with coinItem: [CoinItem] = [], at index: Int) {
            completions[index](.success(coinItem))
        }
    }

}

private extension CryptoCoinCell {
    var symbolText: String {
        return symbolLabel.text!
    }
    
    var nameText: String {
        return nameLabel.text!
    }
    
    var priceText: String {
        return priceLabel.text!
    }
    
    var dayPerformanceText: String {
        return dayPerformanceLabel.text!
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent:
                    .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private extension CoinViewController {
    func cryptoCoinView(at index: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: index, section: cryptoCoinSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func numberOfRenderedCoinViews() -> Int {
        tableView.numberOfRows(inSection: cryptoCoinSection)
    }
    
    private var cryptoCoinSection: Int {
        return 0
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    func simulateUserInitiatedCoinReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateAppearance() {
        if !isViewAppeared {
            loadViewIfNeeded()
            prepareForFirstAppearance()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    private func prepareForFirstAppearance() {
        setSmallFrameToPreventRenderingCells()
        replaceRefreshControlWithFakeForiOS17Support()
    }
    
    private func setSmallFrameToPreventRenderingCells() {
        tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }
    
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent:
                    .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        refreshControl = fake
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool {
        _isRefreshing
    }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

