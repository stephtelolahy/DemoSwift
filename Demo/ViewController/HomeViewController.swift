//
//  HomeViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, CategoriesManagerDelegate, UITableViewDataSource, UITableViewDelegate, StoresViewControllerDelegate {


    // MARK: - Fields

    var window: UIWindow?

    var categoriesManager: CategoriesManager?
    var categories: Array<Category>?
    

    // MARK: - Outlet

    @IBOutlet weak var tableView: UITableView!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(title: "Stores", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.storesBarButtonItemAction(_:))), animated: true)

        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Account", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HomeViewController.accountBarButtonItemAction(_:))), animated: true)

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reload()
    }


    // MARK: - Action

    func storesBarButtonItemAction(sender: AnyObject) {

        let storesViewController = StoresViewController()

        storesViewController.delegate = self
        
        self.navigationController!.pushViewController(storesViewController, animated: true)
    }

    func accountBarButtonItemAction(sender: AnyObject) {

        let alert = UIAlertController(title: "Account", message: "You are logged as \(AppConfig.currentUser!.username)", preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (action: UIAlertAction!) in
            self.logout()

        }))

        alert.addAction(UIAlertAction(title: "Dissmiss", style: .Cancel, handler: nil))

        presentViewController(alert, animated: true, completion: nil)

    }


    // MARK: - CategoriesManagerDelegate

    func categoriesManager(manager: CategoriesManager, didSucceedWithCategories categories: Array<Category>) {

        hideLoadingView()

        self.categories = categories
        self.tableView.reloadData()

    }

    func categoriesManager(manager: CategoriesManager, didFailWithError error: NSError) {

        hideLoadingView()

        showError(error.description)
    }


    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.categories == nil {
            return 0;
        } else {
            return self.categories!.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let position = indexPath.item
        let category = self.categories![position]

        let cell = UITableViewCell()
        cell.textLabel!.text = category.name
        return cell
    }


    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        print("select item at index \(indexPath.item)")
    }


    // MARK: - StoresViewControllerDelegate

    func storesViewController(viewController: StoresViewController, didSelectStore: Store) {

        AppConfig.currentStore = didSelectStore

        reload()

        self.navigationController?.popViewControllerAnimated(true)
    }


    // MARK: - Private

    private func logout() {

        // drop current user
        AppConfig.currentUser = nil

        let userFilePath = ServiceAtlas.cachePathForService(.ServiceUser, parameters: nil)
        CacheUtil.deleteFile(userFilePath!)

        // move to login screen
        let loginViewController = LoginViewController()
        self.window!.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()
    }

    private func reload() {

        self.title = AppConfig.currentStore!.name

        categoriesManager = CategoriesManager()
        categoriesManager!.delegate = self
        categoriesManager?.start(AppConfig.currentStore!.id)


        if (self.categories == nil) {
            showLoadingView()
        }

    }

}
