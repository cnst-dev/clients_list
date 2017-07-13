//
//  ClientsManager.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 29.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit

/// A class to manage clients.
class ClientsManager: NSObject {

    // MARK: - Properties
    private var currentClients = [Client]()
    private var pastClients = [Client]()

    /// The number of clients in the curent clients array.
    var currentClientsCount: Int {
        return currentClients.count
    }

    /// The number of clients in the past clients array.
    var pastClientsCount: Int {
        return pastClients.count
    }

    /// URL for clients.plist file in the Document Directory.
    var clientsPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else { fatalError("There should be a documents url!") }

        return documentURL.appendingPathComponent("clients.plist")
    }

    // MARK: - Inits
    override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(save), name: .UIApplicationWillResignActive, object: nil)

        if let clients = NSArray(contentsOf: clientsPathURL) {
            for dictionary in clients {
                if let dictionary = dictionary as? [String: Any],
                    let client = Client(dictionary: dictionary) {
                    currentClients.append(client)
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }

    // MARK: - Methods
    /// Adds a new unique client to the end of the current clients array.
    ///
    /// - Parameter client: The new client to add.
    func add(_ client: Client) {
        if !currentClients.contains(client) {
            currentClients.append(client)
        }
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

    /// Removes the client from the specified position in the past clients array
    /// and adds to the end of the current clients array.
    ///
    /// - Parameter index: The position of the client.
    func returnClient(from index: Int) {
        let client = pastClients.remove(at: index)
        currentClients.append(client)

    }

    /// Returns the client at the specified position in the pass clients array.
    ///
    /// - Parameter index: The position of the client to return.
    /// - Returns: The client from the past clients array.
    func pastClient(at index: Int) -> Client {
        return pastClients[index]
    }

    /// Removes all clients from the arrays.
    func removeAll() {
        currentClients.removeAll()
        pastClients.removeAll()
    }

    func save() {
        let clients = currentClients.map { $0.plistDictionary }

        guard clients.count > 0 else {
            try? FileManager.default.removeItem(at: clientsPathURL)
            return
        }
        do {
            let plistData = try PropertyListSerialization.data(
                fromPropertyList: clients,
                format: PropertyListSerialization.PropertyListFormat.xml,
                options: PropertyListSerialization.WriteOptions(0))
            try plistData.write(to: clientsPathURL, options: Data.WritingOptions.atomic)
        } catch {
            print(error)
        }
    }
}
