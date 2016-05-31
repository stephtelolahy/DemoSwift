//
//  HomeViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, CategoriesManagerDelegate, UITableViewDataSource, UITableViewDelegate {


    // MARK: - Fields

    var window: UIWindow?

    var categoriesManager: CategoriesManager?
    var categories: Array<Category>?
    

    // MARK: - Outlet

    @IBOutlet weak var titleBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var userBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        self.titleBarButtonItem.title = AppConfig.availableStores![0].name
        self.userBarButtonItem.title = AppConfig.currentUser!.username

        self.tableView.dataSource = self
        self.tableView.delegate = self

//        let cellNibCategorie = UINib(nibName: "CategorieTableViewCell", bundle: NSBundle.mainBundle())
//        TableOutlet.registerNib(cellNibCategorie, forCellReuseIdentifier: CellIdentifierCategorie)
//        self.TableOutlet.rowHeight = 65
//        self.TableOutlet.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.TableOutlet.frame.width, height: 1))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        categoriesManager = CategoriesManager()
        categoriesManager!.delegate = self
        categoriesManager?.start(AppConfig.currentStore().id)

        showLoadingView()
    }


    // MARK: - Action

    @IBAction func storesBarButtonItemAction(sender: AnyObject) {

    }

    @IBAction func userBarButtonItemAction(sender: AnyObject) {

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

//        let cell =  tableView.dequeueReusableCellWithIdentifier(CellIdentifierCategorie) as! CategorieTableViewCell
//        cell.affecter(block!)
        return cell
    }


    // MARK:- UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        print("select item at index \(indexPath.item)")
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

}
