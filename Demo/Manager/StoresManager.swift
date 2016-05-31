//
//  StoresManager.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol StoresManagerDelegate {

    func storesManager(manager: StoresManager, didSucceedWithStores stores:Array<Store>)

    func storesManager(manager: StoresManager, didFailWithError error:NSError)
}

class StoresManager: AnyObject, ModelNetworkOperationDelegate, ModelCacheOperationDelegate {


    // MARK: - Fields

    var delegate: StoresManagerDelegate?

    private var networkOperation: ModelNetworkOperation?
    private var cacheOperation: ModelCacheOperation?
    
    private var networkError: NSError?


    // MARK: - Public

    func start() {

        networkOperation = ModelNetworkOperation(service: .ServiceStores, parameters: nil)
        networkOperation?.delegate = self
        ModelNetworkOperation.sharedQueue.addOperation(networkOperation!)
    }


    // MARK: - ModelNetworkOperationDelegate

    func modelNetworkOperation(operation: ModelNetworkOperation, didSucceedWithModel model: AnyObject) {

        let stores: Array<Store>  = model as! Array<Store>
        self.delegate?.storesManager(self, didSucceedWithStores: stores)
    }

    func modelNetworkOperation(operation: ModelNetworkOperation, didFailWithError error: NSError) {

        self.networkError = error

        cacheOperation = ModelCacheOperation(service: .ServiceStores, parameters:nil)
        cacheOperation?.delegate = self
        ModelCacheOperation.sharedQueue.addOperation(cacheOperation!)
    }


    // MARK: - ModelCacheOperationDelegate

    func modelCacheOperation(operation: ModelCacheOperation, didSucceedWithModel model: AnyObject) {

        let stores: Array<Store>  = model as! Array<Store>
        self.delegate?.storesManager(self, didSucceedWithStores: stores)
    }

    func modelCacheOperation(operation: ModelCacheOperation, didFailWithError error: NSError) {

        self.delegate?.storesManager(self, didFailWithError: self.networkError!)
    }

}

