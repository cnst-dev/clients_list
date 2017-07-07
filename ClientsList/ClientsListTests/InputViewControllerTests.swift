//
//  InputViewControllerTests.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 06.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ClientsList

class InputViewControllerTests: XCTestCase {

    var sut: InputViewController!
    var placeMark: MockPlaceMark!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Input", bundle: nil)

        guard let controller = storyboard.instantiateInitialViewController() as? InputViewController else {
            XCTFail("There should be a view controller")
            return
        }

        sut = controller

        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_HasNameTextField() {
        XCTAssertNotNil(sut.nameTextField)
    }

    func test_HasDateTextField() {
        XCTAssertNotNil(sut.dateTextField)
    }

    func test_HasLocationTextField() {
        XCTAssertNotNil(sut.locationTextField)
    }

    func test_HasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }

    func test_HasInfoTextField() {
        XCTAssertNotNil(sut.infoTextField)
    }

    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }

    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }

    func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        guard let date = dateFormatter.date(from: "02/22/2016") else {
            XCTFail("There should be a date")
            return
        }
        let timestamp = date.timeIntervalSince1970

        sut.nameTextField.text = "Name"
        sut.dateTextField.text = dateFormatter.string(from: date)
        sut.locationTextField.text = "Paris"
        sut.addressTextField.text = "1 Infinite Loop, Cupertino, CA"
        sut.infoTextField.text = "Info"

        let mockGeocoder = MockGeocoder()

        sut.geocoder = mockGeocoder

        sut.clientsManager = ClientsManager()

        sut.save()

        placeMark = MockPlaceMark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placeMark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placeMark], nil)

        let client = sut.clientsManager?.currentClient(at: 0)

        let testClient = Client(name: "Name", info: "Info",
                                timestamp: timestamp,
                                location: Location(name: "Paris", coordinate: coordinate))

        XCTAssertEqual(client, testClient)
    }

    func test_SaveButtonHasSaveAction() {
        let saveButton = sut.saveButton
        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail("There should be an action")
            return
        }

        XCTAssertTrue(actions.contains("save"))
    }

    func test_Geocoder_FetchesCoordinates() {

        let geocoderAnswered = expectation(description: "Geocoder")

        CLGeocoder().geocodeAddressString("1 Infinite Loop, Cupertino, CA") { (placeMarks, _) in

            let coordinate = placeMarks?.first?.location?.coordinate

            guard let latitude = coordinate?.latitude else {
                XCTFail("There should be a latitude")
                return
            }

            guard let longitude = coordinate?.longitude else {
                XCTFail("There should be a longitude")
                return
            }

            XCTAssertEqualWithAccuracy(latitude, 37.3316, accuracy: 0.0001)
            XCTAssertEqualWithAccuracy(longitude, -122.0300, accuracy: 0.001)

            geocoderAnswered.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}

extension InputViewControllerTests {

    class MockGeocoder: CLGeocoder {

        var completionHandler: CLGeocodeCompletionHandler?

        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }

    }

    class MockPlaceMark: CLPlacemark {

        var mockCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}
