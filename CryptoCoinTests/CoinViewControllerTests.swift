//
//  CoinViewControllerTests.swift
//  CryptoCoinTests
//
//  Created by Julius on 02/05/2025.
//

import XCTest
import CryptoCoin

final class CoinViewController: UITableViewController {
    
    private var loader: CoinLoader?
    private var isViewAppeared = false
    private var onViewIsAppearing: ((CoinViewController) -> Void)?
    
    convenience init(loader: CoinLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewIsAppearing = { vc in
            vc.onViewIsAppearing = nil
            vc.load()
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

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
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CoinViewController, loader: LoaderSpy) {
        let client = LoaderSpy()
        let sut = CoinViewController(loader: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    class LoaderSpy: CoinLoader {
        var loadCallCount: Int {
            completions.count
        }
        
        var completions = [(CoinLoader.Result) -> Void]()
        
        func load(completion: @escaping (CoinLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeCoinLoading(at index: Int) {
            completions[index](.success([]))
        }
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

