//
//  CategoryManager.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol CategoriesManagerDelegate {

    func categoriesManager(manager: CategoriesManager, didSucceedWithCategories categories:Array<Category>)

    func categoriesManager(manager: CategoriesManager, didFailWithError error:NSError)
}


class CategoriesManager: AnyObject, ModelNetworkOperationDelegate, ModelCacheOperationDelegate {

    // MARK: - Fields

    var delegate: CategoriesManagerDelegate?

    private var networkOperation: ModelNetworkOperation?
    private var cacheOperation: ModelCacheOperation?

    private var storeId: Int?
    private var networkError: NSError?


    // MARK: - Public

    func start(storeId: Int) {

        self.storeId = storeId

        let parameters: NSDictionary = [Category.KEY_CATEGORY_STORE_ID : self.storeId!]
        networkOperation = ModelNetworkOperation(service: .ServiceCategories, parameters: parameters)
        networkOperation?.delegate = self
        ModelNetworkOperation.sharedQueue.addOperation(networkOperation!)
    }


    // MARK: - ModelNetworkOperationDelegate

    func modelNetworkOperation(operation: ModelNetworkOperation, didSucceedWithModel model: AnyObject) {

        let categories = model as! Array<Category>
        self.delegate?.categoriesManager(self, didSucceedWithCategories: categories)
    }

    func modelNetworkOperation(operation: ModelNetworkOperation, didFailWithError error: NSError) {

        self.networkError = error

        let parameters: NSDictionary = [Category.KEY_CATEGORY_STORE_ID : self.storeId!]
        cacheOperation = ModelCacheOperation(service: .ServiceCategories, parameters: parameters)
        cacheOperation?.delegate = self
        ModelCacheOperation.sharedQueue.addOperation(cacheOperation!)
    }


    // MARK: - ModelCacheOperationDelegate

    func modelCacheOperation(operation: ModelCacheOperation, didSucceedWithModel model: AnyObject) {

        let categories = model as! Array<Category>
        self.delegate?.categoriesManager(self, didSucceedWithCategories: categories)
    }

    func modelCacheOperation(operation: ModelCacheOperation, didFailWithError error: NSError) {
        
        self.delegate?.categoriesManager(self, didFailWithError: self.networkError!)
    }

}
