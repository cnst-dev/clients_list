//
//  ClientsListDataProviderTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 30.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
@testable import ClientsList

class ClientsListDataProviderTests: XCTestCase {

    var sut: ClientsListDataProvider!
    var tableView: UITableView!
    var controller: ClientsListViewController!

    override func setUp() {
        super.setUp()

        sut = ClientsListDataProvider()
        sut.clientsManager = ClientsManager()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let viewController = storyboard.instantiateInitialViewController() as? ClientsListViewController else {
            XCTFail("There should be a view controller")
            return
        }

        controller = viewController

        _ = controller.view

        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_NumberOfSections_IsTwo() {
        let numberOfSections = tableView.numberOfSections

        XCTAssertEqual(numberOfSections, 2)
    }

    func test_NumberOfRows_InFirstSection_IsCurrentClientsCount() {
        sut.clientsManager?.add(Client(name: "Name-1"))

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)

        sut.clientsManager?.add(Client(name: "Name-2"))
        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }

    func test_NumberOfRows_InSecondSection_IsPastClientsCount() {
        sut.clientsManager?.add(Client(name: "Name-1"))
        sut.clientsManager?.add(Client(name: "Name-2"))
        sut.clientsManager?.moveClient(from: 0)

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)

        sut.clientsManager?.moveClient(from: 0)
        tableView.reloadData()

        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }

    func test_CellForRow_ReturnsClientCell() {
        sut.clientsManager?.add(Client(name: "Name-1"))
        tableView.reloadData()

        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(cell is ClientCell)
    }

    func test_CellForRow_DequeuesCellFromTableView() {
        let mockTableView = MockTableView.mockTableView(with: sut)

        sut.clientsManager?.add(Client(name: "Name"))

        mockTableView.reloadData()

        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(mockTableView.cellGotDequeued)
    }

    func testCellForRow_CallsConfigCell() {
        let mockTableView = MockTableView.mockTableView(with: sut)

        let client = Client(name: "Name")

        sut.clientsManager?.add(client)
        mockTableView.reloadData()

        guard let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MockClientCell else {
            XCTFail("There should be a cell")
            return
        }

        XCTAssertEqual(cell.catchedClient, client)
    }

    func test_CellForRow_InSectionTwo_CallsConfigCell() {
        let mockTableView = MockTableView.mockTableView(with: sut)

        sut.clientsManager?.add(Client(name: "Name-1"))

        let second = Client(name: "Name-2")

        sut.clientsManager?.add(second)
        sut.clientsManager?.moveClient(from: 1)

        mockTableView.reloadData()

        guard let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? MockClientCell else {
            XCTFail("There should be a cell")
            return
        }

        XCTAssertEqual(cell.catchedClient, second)
    }

    func test_DeleteButton_InFirstSection_ShowsTitleMove() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(deleteButtonTitle, "Move")
    }

    func test_DeleteButton_InSecondSection_ShowsTitleBack() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))

        XCTAssertEqual(deleteButtonTitle, "Back")
    }

    func test_MoveClient_MovesClientInClientsManager() {
        sut.clientsManager?.add(Client(name: "Name"))
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(sut.clientsManager?.currentClientsCount, 0)
        XCTAssertEqual(sut.clientsManager?.pastClientsCount, 1)

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }

    func test_ReturnClient_ReturnsClientInClientsManager() {
        sut.clientsManager?.add(Client(name: "Name"))
        sut.clientsManager?.moveClient(from: 0)
        tableView.reloadData()
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))

        XCTAssertEqual(sut.clientsManager?.currentClientsCount, 1)
        XCTAssertEqual(sut.clientsManager?.pastClientsCount, 0)

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    }
}

extension ClientsListDataProviderTests {

    class MockTableView: UITableView {
        var cellGotDequeued = false

        class func mockTableView(with dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)

            mockTableView.dataSource = dataSource

            mockTableView.register(MockClientCell.self, forCellReuseIdentifier: "ClientCell")

            return mockTableView
        }

        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequeued = true

            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }

    }

    class MockClientCell: ClientCell {
        var catchedClient: Client?

        override func configCell(with client: Client, moved: Bool = false) {
            catchedClient = client
        }
    }
}
