//
//  StoresManager.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol StoresManagerDelegate {

    func storesManager(_ manager: StoresManager, didSucceedWithStores stores:Array<Store>)

    func storesManager(_ manager: StoresManager, didFailWithError error:NSError)
}

class StoresManager: AnyObject, ModelNetworkOperationDelegate, ModelCacheOperationDelegate {


    // MARK: - Fields

    var delegate: StoresManagerDelegate?

    fileprivate var networkOperation: ModelNetworkOperation?
    fileprivate var cacheOperation: ModelCacheOperation?
    
    fileprivate var networkError: NSError?


    // MARK: - Public

    func start() {

        networkOperation = ModelNetworkOperation(service: .serviceStores, parameters: nil)
        networkOperation?.delegate = self
        ModelNetworkOperation.sharedQueue.addOperation(networkOperation!)
    }


    // MARK: - ModelNetworkOperationDelegate

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didSucceedWithModel model: AnyObject) {

        let stores = model as! Array<Store>
        self.delegate?.storesManager(self, didSucceedWithStores: stores)
    }

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didFailWithError error: NSError) {

        self.networkError = error

        cacheOperation = ModelCacheOperation(service: .serviceStores, parameters:nil)
        cacheOperation?.delegate = self
        ModelCacheOperation.sharedQueue.addOperation(cacheOperation!)
    }


    // MARK: - ModelCacheOperationDelegate

    func modelCacheOperation(_ operation: ModelCacheOperation, didSucceedWithModel model: AnyObject) {

        let stores = model as! Array<Store>
        self.delegate?.storesManager(self, didSucceedWithStores: stores)
    }

    func modelCacheOperation(_ operation: ModelCacheOperation, didFailWithError error: NSError) {

        self.delegate?.storesManager(self, didFailWithError: self.networkError!)
    }

}

