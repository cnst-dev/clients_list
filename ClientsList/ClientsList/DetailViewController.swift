//
//  DetailViewController.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 06.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties
    var clientsInfo: (clientsManager: ClientsManager, index: Int)?

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    // MARK: - UIViewController
    /// Sets client's data to labels.
    ///
    /// - Parameter animated: If true, using an animation.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let clientsInfo = clientsInfo else { return }
        let client = clientsInfo.clientsManager.currentClient(at: clientsInfo.index)

        nameLabel.text = client.name
        locationLabel.text = client.location?.name
        infoLabel.text = client.info

        if let timestamp = client.timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        }

        if let coordinate = client.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            mapView.region = region
        }
    }

    // MARK: - Methods
    /// Moves the client to the past clients.
    func moveClient() {
        guard let clientsInfo = clientsInfo else { return }
        clientsInfo.clientsManager.moveClient(from: clientsInfo.index)
    }

}
