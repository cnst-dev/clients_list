//
//  LocationTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ClientsList

class LocationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_Init_WhenGivenCoordinate_SetsCoordinate() {
        let coordinate = CLLocationCoordinate2D(latitude: 1.0, longitude: 2.0)

        let location = Location(name: "", coordinate: coordinate)

        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }

    func test_Init_WhenGivenName_SetsName() {
        let location = Location(name: "Paris")

        XCTAssertEqual(location.name, "Paris")
    }

    func test_EqualLocations_AreEqual() {
        let first = Location(name: "Paris")
        let second = Location(name: "Paris")

        XCTAssertEqual(first, second)
    }

    func test_Locations_WhenLatitudeDiffers_AreNotEqual() {
        performNotEqualTestWith(firstName: "Paris", secondName: "Paris", firstLongLat: (0.0, 0.0), secondLongLat: (1.0, 0.0))
    }

    func test_Locations_WhenLongitudeDiffers_AreNotEqual() {
        performNotEqualTestWith(firstName: "Paris", secondName: "Paris", firstLongLat: (0.0, 0.0), secondLongLat: (0.0, 1.0))
    }

    func test_Locations_WhenOneHasCoordinate_AreNotEqual() {
        performNotEqualTestWith(firstName: "Paris", secondName: "Paris", firstLongLat: (0.0, 0.0), secondLongLat: nil)
    }

    func test_Locations_WhenNamesDiffer_AreNotEqual() {
        performNotEqualTestWith(firstName: "Paris", secondName: "Madrid", firstLongLat: nil, secondLongLat: nil)
    }

    func performNotEqualTestWith(
        firstName: String, secondName: String,
        firstLongLat: (Double, Double)?,
        secondLongLat: (Double, Double)?) {

        var firstCoord: CLLocationCoordinate2D?

        if let firstLongLat = firstLongLat {
            firstCoord = CLLocationCoordinate2D(latitude: firstLongLat.0, longitude: firstLongLat.1)
        }
        let firstLocation = Location(name: firstName, coordinate: firstCoord)

        var secondCoord: CLLocationCoordinate2D?

        if let secondLongLat = secondLongLat {
            secondCoord = CLLocationCoordinate2D(latitude: secondLongLat.0, longitude: secondLongLat.1)
        }
        let secondLocation = Location(name: secondName, coordinate: secondCoord)

        XCTAssertNotEqual(firstLocation, secondLocation)
    }
}
