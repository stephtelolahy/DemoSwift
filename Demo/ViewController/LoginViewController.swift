//
//  LoginViewController.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Outlet

    @IBAction func validateButtonTouchUpInside(sender: AnyObject) {

        let homeViewController = HomeViewController()
        self.presentViewController(homeViewController, animated: false, completion: nil)

    }

}
