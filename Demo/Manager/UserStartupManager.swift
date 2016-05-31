//
//  UserStartupManager.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol UserStartupManagerDelegate {

    func userStartupManagerDidSucceed(manager: UserStartupManager, user: User)
    func userStartupManagerDidFail(manager: UserStartupManager, error: NSError)
}

class UserStartupManager: AnyObject, ModelCacheOperationDelegate, ModelNetworkOperationDelegate {

    // MARK: - Fields

    var delegate: UserStartupManagerDelegate?

    private var cacheOperation: ModelCacheOperation?
    private var networkOperation: ModelNetworkOperation?
    
    private var cachedUser:User?


    // MARK: - Public

    func start() {

        cacheOperation = ModelCacheOperation(service: .ServiceUser, parameters:nil)
        cacheOperation?.delegate = self
        ModelCacheOperation.sharedQueue.addOperation(cacheOperation!)
    }


    // MARK: - ModelCacheOperationDelegate

    func modelCacheOperation(operation: ModelCacheOperation, didSucceedWithModel model: AnyObject) {

        self.cachedUser = model as? User

        let parameters:NSDictionary = [User.KEY_USER_NAME : self.cachedUser!.username, User.KEY_USER_PASSOWRD : self.cachedUser!.password]
        networkOperation = ModelNetworkOperation(service: .ServiceUser,parameters: parameters)
        networkOperation?.delegate = self
        ModelNetworkOperation.sharedQueue.addOperation(networkOperation!)
    }

    func modelCacheOperation(operation: ModelCacheOperation, didFailWithError error: NSError) {

        self.delegate?.userStartupManagerDidFail(self, error: error)
    }


    // MARK - ModelNetworkOperationDelegate

    func modelNetworkOperation(operation: ModelNetworkOperation, didSucceedWithModel model: AnyObject) {

        let user: User  = model as! User
        self.delegate?.userStartupManagerDidSucceed(self, user:user)
    }

    func modelNetworkOperation(operation: ModelNetworkOperation, didFailWithError error: NSError) {

        // Call no startup user
        self.delegate?.userStartupManagerDidFail(self, error: error)
    }

}