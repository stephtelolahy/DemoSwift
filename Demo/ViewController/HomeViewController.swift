//
//  HomeViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {


    // MARK: - Fields

    var window: UIWindow?
    

    // MARK: - Outlet

    @IBOutlet weak var titleBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var userBarButtonItem: UIBarButtonItem!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        self.titleBarButtonItem.title = AppConfig.availableStores![0].name
        self.userBarButtonItem.title = AppConfig.currentUser!.username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
