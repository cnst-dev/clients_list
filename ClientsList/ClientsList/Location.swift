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

    // MARK: - Properties
    let name: String
    let coordinate: CLLocationCoordinate2D?

    // MARK: - Inits
    init(name: String, coordinate: CLLocationCoordinate2D? = nil) {
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
