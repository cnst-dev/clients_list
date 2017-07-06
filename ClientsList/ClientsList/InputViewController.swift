//
//  InputViewController.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 06.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    // MARK: - Properties
    lazy var geocoder = CLGeocoder()
    var clientsManager: ClientsManager?

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    // MARK: - Methods
    /// Saves a new client to the current clients array.
    @IBAction func save() {
        guard let nameString = nameTextField.text, nameString.characters.count > 0 else { return }

        let date: Date?

        if let dateText = dateTextField.text, dateText.characters.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }

        let infoString = infoTextField.text

        if let locationName = locationTextField.text, locationName.characters.count > 0 {
            if let address = addressTextField.text, address.characters.count > 0 {
                geocoder.geocodeAddressString(address) { [unowned self] (placeMarks, _) in
                    let placeMark = placeMarks?.first

                    let client = Client(name: nameString, info: infoString,
                                        timestamp: date?.timeIntervalSince1970,
                                        location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))

                    self.clientsManager?.add(client)
                }
            }
        }

    }
}
