//
//  Location.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation
import CoreLocation

/// A location model struct.
struct Location: Equatable {

    // MARK: - Keys
    private let nameKey = "name"
    private let latitudeKey = "latitudeKey"
    private let longitudeKey = "longitudeKey"

    // MARK: - Properties
    let name: String
    let coordinate: CLLocationCoordinate2D?

    var plistDictionary: [String: Any] {
        var dict = [String: Any]()

        dict[nameKey] = name

        if let coordinate = coordinate {
            dict[latitudeKey] = coordinate.latitude
            dict[longitudeKey] = coordinate.longitude
        }

        return dict
    }

    // MARK: - Inits
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }

    init?(dictionary: [String: Any]) {
        guard let name = dictionary[nameKey] as? String else { return nil }

        let coordinate: CLLocationCoordinate2D?

        if let latitude = dictionary[latitudeKey] as? Double, let longitude = dictionary[longitudeKey] as? Double {
            coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        } else {
            coordinate = nil
        }

        self.name = name
        self.coordinate = coordinate
    }
}

func == (lhs: Location, rhs: Location) -> Bool {
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude {
        return false
    }
    if lhs.coordinate?.longitude != rhs.coordinate?.longitude {
        return false
    }
    if lhs.name != rhs.name {
        return false
    }
    return  true
}
