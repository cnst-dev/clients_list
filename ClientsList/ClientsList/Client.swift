//
//  Client.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation
import CoreLocation

/// A client model struct.
struct Client: Equatable {

    // MARK: - Keys
    private let nameKey = "nameKey"
    private let infoKey = "infoKey"
    private let timestampKey = "timestampKey"
    private let locationKey = "locationKey"

    // MARK: - Properties
    let name: String
    let info: String?
    let timestamp: Double?
    let location: Location?

    var plistDictionary: [String: Any] {
        var dictionary = [String: Any]()

        dictionary[nameKey] = name

        if let info = info {
            dictionary[infoKey] = info
        }

        if let timestamp = timestamp {
            dictionary[timestampKey] = timestamp
        }

        if let location = location {
            let locationDictionary = location.plistDictionary
            dictionary[locationKey] = locationDictionary
        }

        return dictionary
    }

    // MARK: - Inits
    init(name: String, info: String? = nil,
         timestamp: Double? = nil, location: Location? = nil) {
        self.name = name
        self.info = info
        self.timestamp = timestamp
        self.location = location
    }

    init?(dictionary: [String: Any]) {
        guard let name = dictionary[nameKey] as? String else { return nil }

        self.name = name

        info = dictionary[infoKey] as? String
        timestamp = dictionary[timestampKey] as? Double

        if let locationDictionary = dictionary[locationKey] as? [String: Any] {
            location = Location(dictionary: locationDictionary)
        } else {
            location = nil
        }
    }
}

func == (lhs: Client, rhs: Client) -> Bool {
    if lhs.location != rhs.location {
        return false
    }
    if lhs.timestamp != rhs.timestamp {
        return false
    }
    if lhs.info != rhs.info {
        return false
    }
    if lhs.name != rhs.name {
        return false
    }
    return true
}
