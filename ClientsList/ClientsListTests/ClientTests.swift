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

    func test_Init_WhenGivenTitle_SetsTitle() {
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

        XCTAssertEqual(client.location?.name, location.name, "should set location")
    }
}
