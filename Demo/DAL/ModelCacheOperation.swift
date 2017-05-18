//
//  ModelCacheOperation.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol ModelCacheOperationDelegate {

    func modelCacheOperation(_ operation: ModelCacheOperation, didSucceedWithModel model:AnyObject)

    func modelCacheOperation(_ operation: ModelCacheOperation, didFailWithError error:NSError)
}

class ModelCacheOperation: Operation {

    // MARK: - Shared queue

    class var sharedQueue : OperationQueue {
        struct Static {
            static let instance : OperationQueue = OperationQueue()
        }
        Static.instance.maxConcurrentOperationCount = 1
        return Static.instance
    }


    // MARK: - Fields

    var delegate: ModelCacheOperationDelegate?

    fileprivate var service: ServiceType
    fileprivate var parameters: NSDictionary?


    // MARK: - Constructor

    init(service: ServiceType, parameters: NSDictionary?) {

        self.service = service
        self.parameters = parameters
    }


    // MARK: - Overrride

    override func cancel() {
        super.cancel()
        self.delegate = nil
    }

    override func main() {

        // define cachePath

        let cachePath = ServiceAtlas.cachePathForService(self.service, parameters: self.parameters)

        // load model
        let model: AnyObject?
        do {
            model = try CacheUtil.loadModel(cachePath!)
        } catch let error1 as NSError {
            sendFailureWithError(error1)
            return
        }

        // send success
        sendSuccessWithModel(model!)
    }


    // MARK: - Delegate call

    fileprivate func sendSuccessWithModel(_ model: AnyObject) {
        DispatchQueue.main.sync(execute: {
            self.delegate?.modelCacheOperation(self, didSucceedWithModel: model)
        })
    }

    fileprivate func sendFailureWithError(_ error: NSError) {
        DispatchQueue.main.sync(execute: {
            self.delegate?.modelCacheOperation(self, didFailWithError: error)
        })
    }

}

