//
//  Client.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation

/// A client model struct.
struct Client: Equatable {

    // MARK: - Properties
    let name: String
    let info: String?
    let timestamp: Double?
    let location: Location?

    // MARK: - Inits
    init(name: String, info: String? = nil,
         timestamp: Double? = nil, location: Location? = nil) {
        self.name = name
        self.info = info
        self.timestamp = timestamp
        self.location = location
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
