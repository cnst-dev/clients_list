//
//  Client.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation

/// A client model struct.
struct Client {

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
