//
//  ClientsManager.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation

/// A class to manage clients.
class ClientsManager {

    // MARK: - Properties
    private var currentClients = [Client]()
    private var pastClients = [Client]()

    /// The number of clients in the cureent clients array.
    var currentClientsCount: Int {
        return currentClients.count
    }

    /// The number of clients in the past clients array.
    var pastClientsCount: Int {
        return pastClients.count
    }

    // MARK: - Methods

    /// Adds a new client to the end of the current clients array.
    ///
    /// - Parameter client: The new client to add.
    func add(_ client: Client) {
        currentClients.append(client)
    }

    /// Returns the client at the specified position in the current clients array.
    ///
    /// - Parameter index: The position of the client to return.
    /// - Returns: The client from the current clients array.
    func currentClient(at index: Int) -> Client {
        return currentClients[index]
    }

    /// Removes the client from the specified position in the current clients array
    /// and adds to the end of the past clients array.
    ///
    /// - Parameter index: The position of the client.
    func moveClient(from index: Int) {
        let client = currentClients.remove(at: index)
        pastClients.append(client)
    }

    /// Returns the client at the specified position in the pass clients array.
    ///
    /// - Parameter index: The position of the client to return.
    /// - Returns: The client from the past clients array.
    func pastClient(at index: Int) -> Client {
        return pastClients[index]
    }
}
