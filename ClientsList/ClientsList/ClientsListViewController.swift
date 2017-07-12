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
    @IBOutlet weak var dataProvider: (UITableViewDataSource & UITableViewDelegate & ClientsManagerSettable)!

    // MARK: - Properties
    let clientsManager = ClientsManager()

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider

        dataProvider.clientsManager = clientsManager

        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(sender:)),
                                               name: NSNotification.Name("ClientSelected"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Methods

    /// Pushes a detail View Controller.
    ///
    /// - Parameter sender: A NSNotification instance.
    func showDetails(sender: NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else { fatalError() }
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)

        guard let nextViewController = storyboard.instantiateInitialViewController() as? DetailViewController else { fatalError() }

        nextViewController.clientsInfo = (clientsManager, index)
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    // MARK: - Actions
    /// Presents the input ViewController.
    ///
    /// - Parameter sender: A sender button.
    @IBAction func addClient(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Input", bundle: nil)

        guard let nextViewController = storyboard.instantiateInitialViewController() as? InputViewController else { return }
        nextViewController.clientsManager = clientsManager
        present(nextViewController, animated: true, completion: nil)
    }
}
