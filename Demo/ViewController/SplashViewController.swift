//
//  SplashViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, UserStartupManagerDelegate {

    // MARK: - Fields

    var window: UIWindow?

    let userStartupManager = UserStartupManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        userStartupManager.delegate = self
        userStartupManager.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
