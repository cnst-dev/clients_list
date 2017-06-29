//
//  ClientsManagerTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
@testable import ClientsList

class ClientsManagerTests: XCTestCase {

    var sut: ClientsManager!

    override func setUp() {
        super.setUp()
        sut = ClientsManager()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_CurrentClientsCount_Initially_IsZero() {
        XCTAssertEqual(sut.currentClientsCount, 0)
    }

    func test_PastClientsCount_Initially_IsZero() {
        XCTAssertEqual(sut.pastClientsCount, 0)
    }

    func test_AddClient_IncreasesCurrenClientsCountToOne() {
        sut.add(Client(name: "Name"))

        XCTAssertEqual(sut.currentClientsCount, 1)
    }

    func test_CurrentClientAt_ReturnsThatClient() {
        let client = Client(name: "Name")
        sut.add(client)
        let returned = sut.currentClient(at: 0)

        XCTAssertEqual(returned.name, client.name)
    }

    func test_MoveClientFrom_ChangesCounts() {
        sut.add(Client(name: "Name"))
        sut.moveClient(from: 0)

        XCTAssertEqual(sut.currentClientsCount, 0)
        XCTAssertEqual(sut.pastClientsCount, 1)
    }

    func test_MoveClientFrom_RemovesItFromCurrentClients() {
        let first = Client(name: "Client-1")
        let second = Client(name: "Client-2")
        sut.add(first)
        sut.add(second)

        sut.moveClient(from: 0)

        XCTAssertEqual(sut.currentClient(at: 0).name, "Client-2")
    }

    func test_PastClientAt_ReturnsPastClient() {
        let client = Client(name: "Client")
        sut.add(client)

        sut.moveClient(from: 0)
        let returned = sut.pastClient(at: 0)

        XCTAssertEqual(returned.name, client.name)
    }
}
