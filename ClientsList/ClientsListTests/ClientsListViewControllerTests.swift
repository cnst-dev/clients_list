//
//  ClientsListViewControllerTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 30.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
@testable import ClientsList

class ClientsListViewControllerTests: XCTestCase {

    var sut: ClientsListViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let viewController = storyboard.instantiateInitialViewController() as? ClientsListViewController else {
            XCTFail("There should be a view controller")
            return
        }

        sut = viewController

        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_TableView_IsNotNil_AfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }

    func test_LoadingView_SetsTableViewDataSource() {
        XCTAssertTrue(sut.tableView.dataSource is ClientsListDataProvider)
    }

    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertTrue(sut.tableView.delegate is ClientsListDataProvider)
    }

    func test_LoadingView_SetsDataSourceAndDelegateToSameObject() {
        XCTAssertEqual(sut.tableView.dataSource as? ClientsListDataProvider, sut.tableView.delegate as? ClientsListDataProvider)
    }
}
