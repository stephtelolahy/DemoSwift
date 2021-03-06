//
//  BaseViewController.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    func showError(errorMessage: String) {

        let alertController = UIAlertController(title: "Oops", message:
            errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func showLoadingView() {

        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)

        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        self.presentViewController(alert, animated: true, completion: nil)

    }

    func hideLoadingView() {

        self.dismissViewControllerAnimated(false, completion: nil)
    }

}
