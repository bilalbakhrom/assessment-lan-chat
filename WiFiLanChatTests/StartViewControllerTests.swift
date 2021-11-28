//
//  StartViewControllerTests.swift
//  WiFiLanChatTests
//
//  Created by Bilol Mamadjanov on 27/11/21.
//

import XCTest
@testable import WiFiLanChat

class StartViewControllerTests: XCTestCase {
    var sut: MockedStartViewController!
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
        let navController = UINavigationController(rootViewController: MockedStartViewController())
        sut = (navController.viewControllers[0] as! MockedStartViewController)
    }
    
    private func loadView() {
        window.addSubview(sut.view)
        // The run loop associated with the current thread has ample time
        // to let the drawing operations to complete.
        RunLoop.current.run(until: Date())
    }

    // MARK: - Tests
    func testController_viewLoads() {
        XCTAssertNotNil(
            sut.view,
            "View not initiated properly"
        )
    }
    
    func testController_opensSearchVCWhenSearchButtonClicked() {
        // Given
        let myPredicate = NSPredicate { input, _ in
            return (input as? UINavigationController)?.topViewController is SearchViewController
        }
        expectation(for: myPredicate, evaluatedWith: sut.navigationController)
        
        // When
        sut.searchRoomButton.sendActions(for: .touchUpInside)
        
        // Then
        waitForExpectations(timeout: 2)
    }
}
