//
//  ClientsListViewController.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 30.06.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import UIKit

class ClientsListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: (UITableViewDataSource & UITableViewDelegate)!

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
}
