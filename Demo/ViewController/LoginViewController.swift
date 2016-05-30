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

    // MARK: - Outlet

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Action

    @IBAction func validateButtonTouchUpInside(sender: AnyObject) {

        let loginManager = LoginManager()
        loginManager.delegate = self
        loginManager.start(usernameTextField.text!,  password: passwordTextField.text!)

        self.showLoadingView()
    }


    // MARK: - LoginManagerDelegate

    func loginManager(manager: LoginManager, didSucceedWithUser user: User) {

        self.hideLoadingView()

        // save current user
        AppConfig.currentUser = user

        // move to home screen
        let homeViewController = HomeViewController()
        self.window!.rootViewController = homeViewController
        self.window?.makeKeyAndVisible()
    }

    func loginManager(manager: LoginManager, didFailWithError error: NSError) {

        self.hideLoadingView()

        let alertController = UIAlertController(title: "Oops", message:
            error.description, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
}
