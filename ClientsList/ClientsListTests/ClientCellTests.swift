//
//  ClientCellTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 06.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
@testable import ClientsList

class ClientCellTests: XCTestCase {

    var tableView: UITableView!
    let dataSource = FakeDataSource()
    var cell: ClientCell!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let controller = storyboard.instantiateViewController(withIdentifier: "ClientsListViewController") as? ClientsListViewController else {
            XCTFail("There should be a view controller")
            return
        }

        _ = controller.view

        tableView = controller.tableView

        tableView?.dataSource = dataSource

        guard let cell = tableView?.dequeueReusableCell(withIdentifier: "ClientCell", for: IndexPath(row: 0, section: 0)) as? ClientCell else {
            XCTFail("There should be a cell")
            return
        }

        self.cell = cell
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_HasNameLabel() {
        XCTAssertNotNil(cell.nameLabel)
    }

    func test_HasLocationLabel() {
        XCTAssertNotNil(cell.locationLabel)
    }

    func test_HasInfoLabel() {
        XCTAssertNotNil(cell.dateLabel)
    }

    func test_ConfigCell_SetsLabelTexts() {
        let location = Location(name: "Paris")
        let client = Client(name: "Name", info: nil, timestamp: 1456150025, location: location)

        cell.configCell(with: client)

        XCTAssertEqual(cell.nameLabel.text, client.name)
        XCTAssertEqual(cell.locationLabel.text, client.location?.name)
        XCTAssertEqual(cell.dateLabel.text, "02/22/2016")
    }

    func test_Title_WhenClientIsMoved_IsStrokeThrough() {
        let location = Location(name: "Paris")
        let client = Client(name: "Name", info: nil, timestamp: 1456150025, location: location)

        cell.configCell(with: client, moved: true)

        let attributedString = NSAttributedString(
            string: "Name",
            attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])

        XCTAssertEqual(cell.nameLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }
}

extension ClientCellTests {

    class FakeDataSource: NSObject, UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
