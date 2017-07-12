//
//  ClientsListDataProvider.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 30.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit

enum Section: Int {
    case currentClients, pastClients
}

class ClientsListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, ClientsManagerSettable {

    // MARK: - Properties
    var clientsManager: ClientsManager?

    // MARK: - UITableViewDataSource
    /// Sets the number of sections in the table view.
    ///
    /// - Parameter tableView:  The table view.
    /// - Returns: The number of sections in tableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    /// Sets the number of rows in each section of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let clientsManager = clientsManager else { return 0 }
        guard let clientsSection = Section(rawValue: section) else { fatalError() }

        let numberOfRows: Int

        switch clientsSection {
        case .currentClients:
            numberOfRows = clientsManager.currentClientsCount
        case .pastClients:
            numberOfRows = clientsManager.pastClientsCount
        }

        return numberOfRows
    }

    /// Sets and configs a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: A cell that the table view can use for the specified row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as? ClientCell else { fatalError() }

        guard let clientsManager = clientsManager else { fatalError() }
        guard let clientsSection = Section(rawValue: indexPath.section) else { fatalError() }

        let client: Client

        switch clientsSection {
        case .currentClients:
            client = clientsManager.currentClient(at: indexPath.row)
        case .pastClients:
            client = clientsManager.pastClient(at: indexPath.row)
        }

        cell.configCell(with: client)

        return cell
    }

    /// Moves clients between the current clients array and the past clients array
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - editingStyle: The cell editing style.
    ///   - indexPath: An index path locating a row in tableView.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let clientsManager = clientsManager else { fatalError() }
        guard let clientsSection = Section(rawValue: indexPath.section) else { fatalError() }

        switch clientsSection {
        case .currentClients:
            clientsManager.moveClient(from: indexPath.row)
        case .pastClients:
            clientsManager.returnClient(from: indexPath.row)
        }

        tableView.reloadData()
    }

    // MARK: - UITableViewDelegate
    /// Sets the title of the delete-confirmation button.
    ///
    /// - Parameters:
    ///   - tableView: The table view.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: A string to used as the title of the delete button.
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let clientsSection = Section(rawValue: indexPath.section) else { fatalError() }

        let buttonTitle: String

        switch clientsSection {
        case .currentClients:
            buttonTitle = "Move"
        case .pastClients:
            buttonTitle = "Back"
        }

        return buttonTitle
    }
}

@objc protocol ClientsManagerSettable {
    var clientsManager: ClientsManager? { get set }
}
