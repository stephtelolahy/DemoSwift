//
//  LoginManager.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol LoginManagerDelegate {

    func loginManager(_ manager: LoginManager, didSucceedWithUser user:User)

    func loginManager(_ manager: LoginManager, didFailWithError error:NSError)
}

class LoginManager: AnyObject, ModelNetworkOperationDelegate {


    // MARK: - Fields

    var delegate: LoginManagerDelegate?

    fileprivate var networkOperation: ModelNetworkOperation?


    // MARK: - Methods

    func start(_ username:String, password:String) {

        let parameters:NSDictionary = [User.KEY_USER_NAME : username, User.KEY_USER_PASSOWRD : password]
        networkOperation = ModelNetworkOperation(service: .serviceUser,parameters: parameters)
        networkOperation?.delegate = self
        ModelNetworkOperation.sharedQueue.addOperation(networkOperation!)
    }

    
    // MARK: - ModelNetworkOperationDelegate

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didSucceedWithModel model: AnyObject) {

        let user = model as! User
        self.delegate?.loginManager(self, didSucceedWithUser: user)
    }

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didFailWithError error: NSError) {

        self.delegate?.loginManager(self, didFailWithError: error)
    }

}
