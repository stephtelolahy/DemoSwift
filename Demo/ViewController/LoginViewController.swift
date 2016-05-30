//
//  LoginViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginManagerDelegate {


    // MARK: - Outlet

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }


    // MARK: - LoginManagerDelegate

    func loginManager(manager: LoginManager, didSucceedWithUser user: User) {

        // save current user
        AppConfig.currentUser = user

        let homeViewController = HomeViewController()
        self.presentViewController(homeViewController, animated: false, completion: nil)
    }

    func loginManager(manager: LoginManager, didFailWithError error: NSError) {

        let alertController = UIAlertController(title: "Oops", message:
            error.description, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)

    }

}
