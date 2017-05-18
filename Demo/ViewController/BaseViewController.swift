//
//  BaseViewController.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    func showError(_ errorMessage: String) {

        let alertController = UIAlertController(title: "Oops", message:
            errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }

    func showLoadingView() {

//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        alert.view.tintColor = UIColor.black
//        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        self.present(alert, animated: true, completion: nil)

    }

    func hideLoadingView() {

//        self.dismiss(animated: false, completion: nil)
    }

}
