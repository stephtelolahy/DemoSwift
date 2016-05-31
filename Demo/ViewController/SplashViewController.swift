//
//  SplashViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController, StoresManagerDelegate, UserStartupManagerDelegate {

    // MARK: - Fields

    var window: UIWindow?

    var storesManager: StoresManager?
    var userStartupManager: UserStartupManager?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        // fetch stores
        storesManager = StoresManager()
        storesManager?.delegate = self
        storesManager?.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - StoresManagerDelegate

    func storesManager(manager: StoresManager, didSucceedWithStores stores: Array<Store>) {

        // save available stores
        AppConfig.availableStores = stores

        // fetch user
        userStartupManager =  UserStartupManager()
        userStartupManager!.delegate = self
        userStartupManager?.start()
    }

    func storesManager(manager: StoresManager, didFailWithError error: NSError) {

        showError(error.description)
    }


    // MARK: - UserStartupManagerDelegate

    func userStartupManagerDidSucceed(manager: UserStartupManager, user: User) {

        // save current user
        AppConfig.currentUser = user

        // move to home screen
        let homeViewController = HomeViewController()
        self.window!.rootViewController = homeViewController
        self.window?.makeKeyAndVisible()
    }

    func userStartupManagerDidFail(manager: UserStartupManager, error: NSError) {

        // move to login screen
        let loginViewController = LoginViewController()
        self.window!.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()
    }

}
