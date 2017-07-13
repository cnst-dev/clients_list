//
//  ClientTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
@testable import ClientsList

class ClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_Init_WhenGivenName_SetsName() {
        let client = Client(name: "Name")

        XCTAssertEqual(client.name, "Name", "should set name")
    }

    func test_Init_WhenGivenInfo_SetsInfo() {
        let client = Client(name: "", info: "Info")

        XCTAssertEqual(client.info, "Info", "should set info")
    }

    func test_Init_WhenGivenTimestamp_SetsTimestamp() {
        let client = Client(name: "Name", timestamp: 0.0)

        XCTAssertEqual(client.timestamp, 0.0, "should set timestamp")
    }

    func test_Init_WhenGivenLocation_SetsLocation() {
        let location = Location(name: "Paris")
        let client = Client(name: "", location: location)

        XCTAssertEqual(client.location, location, "should set location")
    }

    func test_EqualClients_AreEqual() {
        let first = Client(name: "Name")
        let second = Client(name: "Name")

        XCTAssertEqual(first, second)
    }

    func test_Clients_WhenLocationDiffers_AreNotEqual() {
        let first = Client(name: "", location: Location(name: "Paris"))
        let second = Client(name: "", location: Location(name: "Madrid"))

        XCTAssertNotEqual(first, second)
    }

    func test_Clients_WhenOneLocationIsNil_AreNotEqual() {
        var first = Client(name: "", location: Location(name: "Paris"))
        var second = Client(name: "", location: nil)

        XCTAssertNotEqual(first, second)

        first = Client(name: "", location: nil)
        second = Client(name: "", location: Location(name: "Paris"))

        XCTAssertNotEqual(first, second)
    }

    func test_Clients_WhenTimestampsDiffer_AreNotEqual() {
        let first = Client(name: "Name", timestamp: 1.0)
        let second = Client(name: "Name", timestamp: 2.0)

        XCTAssertNotEqual(first, second)
    }

    func test_Clients_WhenInfoDiffers_AreNotEqual() {
        let first = Client(name: "Name", info: "Info-1")
        let second = Client(name: "Name", info: "Info-2")

        XCTAssertNotEqual(first, second)
    }

    func test_Clients_WhenNamesDiffer_AreNotEqual() {
        let first = Client(name: "Paris")
        let second = Client(name: "Madrid")

        XCTAssertNotEqual(first, second)
    }

    func test_HasPlistDictionaryProperty() {
        let client = Client(name: "Name")
        let dictionary = client.plistDictionary

        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is [String: Any])
    }

    func test_CanBeCreatedFromPlistDicitionary() {
        let location = Location(name: "Paris")
        let client = Client(name: "Name", info: "Info", timestamp: 1.0, location: location)

        let dictionary = client.plistDictionary
        let recreatedClient = Client(dictionary: dictionary)

        XCTAssertEqual(client, recreatedClient)
    }
}
