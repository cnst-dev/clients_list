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

        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ClientsListViewController") as? ClientsListViewController else {
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

    func test_ClientsListViewController_HasAddBarButton() {
        let target = sut.navigationItem.rightBarButtonItem?.target

        XCTAssertEqual(target as? UIViewController, sut)
    }

    func test_AddClient_PresentsInputViewController() {

        XCTAssertNil(sut.presentedViewController)

        onButtonAction()

        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)

        let inputViewController = sut.presentedViewController as? InputViewController

        XCTAssertNotNil(inputViewController?.nameTextField)
    }

    func test_ClientListViewController_SharesClientsManagerWithInputViewController() {
        onButtonAction()

        guard let inputViewController = sut.presentedViewController as? InputViewController else {
            XCTFail("There should be an input View Controller")
            return
        }

        guard let inputClientsManager = inputViewController.clientsManager else {
            XCTFail("There should be a clients manager")
            return
        }

        XCTAssertTrue(sut.clientsManager === inputClientsManager)
    }

    func test_ViewDidLoad_SetsClientsManagerToDataProvider() {
        XCTAssertTrue(sut.clientsManager === sut.dataProvider.clientsManager)
    }

    func test_WillAppear_ReloadsTableView() {
        let tableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)

        sut.tableView = tableView

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertTrue(tableView.reloadGotCalled)
    }

    func testClientSelectedNotification_PushesDetailsViewController() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)

        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController

        _ = sut.view

        sut.clientsManager.add(Client(name: "Name-1"))
        sut.clientsManager.add(Client(name: "Name-2s"))

        NotificationCenter.default.post(name: NSNotification.Name("ClientSelected"),
                                        object: self, userInfo: ["index": 1])
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail("There should be a detail View Controller")
            return
        }

        guard let detailClientsManager = detailViewController.clientsInfo?.clientsManager else {
            XCTFail("There should be a client Manager")
            return
        }

        guard let index = detailViewController.clientsInfo?.index else {
            XCTFail("There should be an index")
            return
        }

        _ = detailViewController.view

        XCTAssertNotNil(detailViewController.nameLabel)
        XCTAssertTrue(detailClientsManager === sut.clientsManager)
        XCTAssertEqual(index, 1)
    }

    func onButtonAction() {
        UIApplication.shared.keyWindow?.rootViewController = sut

        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            XCTFail("There should be a button")
            return
        }

        guard let action = addButton.action else {
            XCTFail("There should be an action")
            return
        }

        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
    }
}

extension ClientsListViewControllerTests {

    class MockTableView: UITableView {

        var reloadGotCalled = false

        override func reloadData() {
            reloadGotCalled = true
            super.reloadData()
        }
    }

    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?

        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
