//
//  DetailViewControllerTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 06.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ClientsList

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Detail", bundle: nil)

        guard let sut = storyboard.instantiateInitialViewController() as? DetailViewController else {
            XCTFail("There should be a view controller")
            return
        }

        self.sut = sut

        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_HasNameLabel() {
        XCTAssertNotNil(sut.nameLabel)
    }

    func test_HasInfoLabel() {
        XCTAssertNotNil(sut.infoLabel)
    }

    func test_HasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
    }

    func test_HasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
    }

    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }

    func test_SettingClientsInfo_SetsToLabels() {
        let coordinate = CLLocationCoordinate2DMake(52.2277, 6.7735)

        let location = Location(name: "Paris", coordinate: coordinate)

        let client = Client(name: "Name", info: "Info", timestamp: 1456150025, location: location)

        let clientsManager = ClientsManager()

        clientsManager.add(client)

        sut.clientsInfo = (clientsManager, 0)

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertEqual(sut.nameLabel.text, client.name)
        XCTAssertEqual(sut.infoLabel.text, client.info)
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.locationLabel.text, location.name)

        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.longitude, coordinate.longitude, accuracy: 0.001)
    }

    func test_MoveClient_MovesClientInClientsManager() {
        let clientsManager = ClientsManager()

        clientsManager.add(Client(name: "Name"))

        sut.clientsInfo = (clientsManager, 0)

        sut.moveClient()

        XCTAssertEqual(clientsManager.currentClientsCount, 0)
        XCTAssertEqual(clientsManager.pastClientsCount, 1)
    }
}
