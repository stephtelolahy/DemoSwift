//
//  LoginViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, LoginManagerDelegate {


    // MARK: - Fields

    var window: UIWindow?

    var loginManager: LoginManager?

    
    // MARK: - Outlet

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.window = UIWindow(frame: UIScreen.main.bounds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Action

    @IBAction func validateButtonTouchUpInside(_ sender: AnyObject) {

        loginManager = LoginManager()
        loginManager!.delegate = self
        loginManager?.start(usernameTextField.text!,  password: passwordTextField.text!)

        self.showLoadingView()
    }


    // MARK: - LoginManagerDelegate

    func loginManager(_ manager: LoginManager, didSucceedWithUser user: User) {

        self.hideLoadingView()

        // save current user
        AppConfig.currentUser = user

        // move to home screen
        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        self.window!.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func loginManager(_ manager: LoginManager, didFailWithError error: NSError) {

        self.hideLoadingView()

        self.showError(error.description)
    }
    
}
