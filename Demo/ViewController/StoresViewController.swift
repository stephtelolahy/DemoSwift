//
//  StoresViewController.swift
//  Demo
//
//  Created by Telolahy on 01/06/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class StoresViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {


    // MARK: - Outlet

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return AppConfig.availableStores!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let position = indexPath.item
        let store = AppConfig.availableStores![position]

        let cell = UITableViewCell()
        cell.textLabel!.text = store.name
        return cell
    }


    // MARK:- UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        print("select item at index \(indexPath.item)")
    }

    
}
