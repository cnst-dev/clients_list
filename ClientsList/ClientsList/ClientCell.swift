//
//  ClientCell.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 30.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit

class ClientCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Properties
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    /// Sets cell's labels for a client.
    ///
    /// - Parameter client: A client.
    func configCell(with client: Client, moved: Bool = false) {
        if moved {
            let attributedString = NSAttributedString(
                string: "Name",
                attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
            nameLabel.attributedText = attributedString
            locationLabel.text = nil
            dateLabel.text = nil
        } else {
            nameLabel.text = client.name
            locationLabel.text = client.location?.name

            guard let timestamp = client.timestamp else { return }

            let date = Date(timeIntervalSince1970: timestamp)

            dateLabel.text = dateFormatter.string(from: date)
        }
    }
}
