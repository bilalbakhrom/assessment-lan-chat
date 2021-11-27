//
//  SearchViewControllerTests.swift
//  WiFiLanChatTests
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import XCTest
@testable import WiFiLanChat

class SearchViewControllerTests: XCTestCase {
    var sut: SearchViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        
        window = UIWindow()
        setupSut()
    }
    
    override func tearDown() {
        sut = nil
        window = nil
        super.tearDown()
    }
    
    func setupSut() {
        let navController = UINavigationController(rootViewController: SearchViewController())
        sut = (navController.viewControllers[0] as! SearchViewController)
    }
    
    private func loadView() {
        window.addSubview(sut.view)
        // The run loop associated with the current thread has ample time
        // to let the drawing operations to complete.
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Tests
}
