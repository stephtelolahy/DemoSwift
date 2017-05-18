//
//  CategoryManager.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol CategoriesManagerDelegate {

    func categoriesManager(_ manager: CategoriesManager, didSucceedWithCategories categories:Array<Category>)

    func categoriesManager(_ manager: CategoriesManager, didFailWithError error:NSError)
}


class CategoriesManager: AnyObject, ModelNetworkOperationDelegate, ModelCacheOperationDelegate {

    // MARK: - Fields

    var delegate: CategoriesManagerDelegate?

    fileprivate var networkOperation: ModelNetworkOperation?
    fileprivate var cacheOperation: ModelCacheOperation?

    fileprivate var storeId: Int?
    fileprivate var networkError: NSError?


    // MARK: - Public

    func start(_ storeId: Int) {

        self.storeId = storeId

        let parameters: NSDictionary = [Category.KEY_CATEGORY_STORE_ID : self.storeId!]
        networkOperation = ModelNetworkOperation(service: .serviceCategories, parameters: parameters)
        networkOperation?.delegate = self
        ModelNetworkOperation.sharedQueue.addOperation(networkOperation!)
    }


    // MARK: - ModelNetworkOperationDelegate

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didSucceedWithModel model: AnyObject) {

        let categories = model as! Array<Category>
        self.delegate?.categoriesManager(self, didSucceedWithCategories: categories)
    }

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didFailWithError error: NSError) {

        self.networkError = error

        let parameters: NSDictionary = [Category.KEY_CATEGORY_STORE_ID : self.storeId!]
        cacheOperation = ModelCacheOperation(service: .serviceCategories, parameters: parameters)
        cacheOperation?.delegate = self
        ModelCacheOperation.sharedQueue.addOperation(cacheOperation!)
    }


    // MARK: - ModelCacheOperationDelegate

    func modelCacheOperation(_ operation: ModelCacheOperation, didSucceedWithModel model: AnyObject) {

        let categories = model as! Array<Category>
        self.delegate?.categoriesManager(self, didSucceedWithCategories: categories)
    }

    func modelCacheOperation(_ operation: ModelCacheOperation, didFailWithError error: NSError) {
        
        self.delegate?.categoriesManager(self, didFailWithError: self.networkError!)
    }

}
