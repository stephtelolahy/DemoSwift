//
//  ModelCacheOperation.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol ModelCacheOperationDelegate {

    func modelCacheOperation(operation: ModelCacheOperation, didSucceedWithModel model:AnyObject)

    func modelCacheOperation(operation: ModelCacheOperation, didFailWithError error:NSError)
}

class ModelCacheOperation: NSOperation {

    // MARK: - Shared queue

    class var sharedQueue : NSOperationQueue {
        struct Static {
            static let instance : NSOperationQueue = NSOperationQueue()
        }
        Static.instance.maxConcurrentOperationCount = 1
        return Static.instance
    }


    // MARK: - Fields

    var delegate: ModelCacheOperationDelegate?

    private var service: ServiceType
    private var parameters: NSDictionary?


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

    private func sendSuccessWithModel(model: AnyObject) {
        dispatch_sync(dispatch_get_main_queue(), {
            self.delegate?.modelCacheOperation(self, didSucceedWithModel: model)
        })
    }

    private func sendFailureWithError(error: NSError) {
        dispatch_sync(dispatch_get_main_queue(), {
            self.delegate?.modelCacheOperation(self, didFailWithError: error)
        })
    }

}

