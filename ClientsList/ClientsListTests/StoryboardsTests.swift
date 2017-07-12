//
//  StoryboardsTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 07.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
@testable import ClientsList

class StoryboardsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_InitialViewController_IsClientsListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            XCTFail("There should be a navigation controller")
            return
        }

        let rootViewController = navigationController.viewControllers[0]

        XCTAssertTrue(rootViewController is ClientsListViewController)
    }
}
