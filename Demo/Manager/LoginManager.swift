//
//  LoginManager.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol LoginManagerDelegate {

    func loginManager(manager: LoginManager, didSucceedWithUser user:User)

    func loginManager(manager: LoginManager, didFailWithError error:NSError)
}

class LoginManager: AnyObject, ModelNetworkOperationDelegate {


    // MARK: - Fields

    var delegate: LoginManagerDelegate?

    private var networkOperation: ModelNetworkOperation?

    // MARK: - Methods

    func start(username:String, password:String) {

        let parameters:NSDictionary = [User.KEY_USERNAME : username, User.KEY_PASSOWRD : password]
        networkOperation = ModelNetworkOperation(service: .ServiceUser,parameters: parameters)
        networkOperation?.delegate = self
        ModelNetworkOperation.sharedQueue.addOperation(networkOperation!)
    }

    // MARK: - ModelNetworkOperationDelegate

    func modelNetworkOperation(operation: ModelNetworkOperation, didSucceedWithModel model: AnyObject) {

        let user: User  = model as! User
        self.delegate?.loginManager(self, didSucceedWithUser: user)
    }

    func modelNetworkOperation(operation: ModelNetworkOperation, didFailWithError error: NSError) {

        self.delegate?.loginManager(self, didFailWithError: error)
    }

}
