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

        self.window = UIWindow(frame: UIScreen.main.bounds)

        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "Stores", style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.storesBarButtonItemAction(_:))), animated: true)

        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Account", style: UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.accountBarButtonItemAction(_:))), animated: true)

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reload()
    }


    // MARK: - Action

    func storesBarButtonItemAction(_ sender: AnyObject) {

        let storesViewController = StoresViewController()

        storesViewController.delegate = self
        
        self.navigationController!.pushViewController(storesViewController, animated: true)
    }

    func accountBarButtonItemAction(_ sender: AnyObject) {

        let alert = UIAlertController(title: "Account", message: "You are logged as \(AppConfig.currentUser!.username)", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
            self.logout()

        }))

        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)

    }


    // MARK: - CategoriesManagerDelegate

    func categoriesManager(_ manager: CategoriesManager, didSucceedWithCategories categories: Array<Category>) {

        hideLoadingView()

        self.categories = categories
        self.tableView.reloadData()

    }

    func categoriesManager(_ manager: CategoriesManager, didFailWithError error: NSError) {

        hideLoadingView()

        showError(error.description)
    }


    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.categories == nil {
            return 0;
        } else {
            return self.categories!.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let position = indexPath.item
        let category = self.categories![position]

        let cell = UITableViewCell()
        cell.textLabel!.text = category.name
        return cell
    }


    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("select item at index \(indexPath.item)")
    }


    // MARK: - StoresViewControllerDelegate

    func storesViewController(_ viewController: StoresViewController, didSelectStore: Store) {

        AppConfig.currentStore = didSelectStore

        reload()

        self.navigationController?.popViewController(animated: true)
    }


    // MARK: - Private

    fileprivate func logout() {

        // drop current user
        AppConfig.currentUser = nil

        let userFilePath = ServiceAtlas.cachePathForService(.serviceUser, parameters: nil)
        CacheUtil.deleteFile(userFilePath!)

        // move to login screen
        let loginViewController = LoginViewController()
        self.window!.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()
    }

    fileprivate func reload() {

        self.title = AppConfig.currentStore!.name

        categoriesManager = CategoriesManager()
        categoriesManager!.delegate = self
        categoriesManager?.start(AppConfig.currentStore!.id)


        if (self.categories == nil) {
            showLoadingView()
        }

    }

}
