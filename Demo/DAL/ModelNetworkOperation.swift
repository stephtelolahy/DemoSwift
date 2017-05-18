//
//  ModelNetworkOperation.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol ModelNetworkOperationDelegate{

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didSucceedWithModel model:AnyObject)

    func modelNetworkOperation(_ operation: ModelNetworkOperation, didFailWithError error:NSError)
}

class ModelNetworkOperation: Operation {


    // MARK: - Shared queue

    class var sharedQueue : OperationQueue {
        struct Static {
            static let instance : OperationQueue = OperationQueue()
        }
        Static.instance.maxConcurrentOperationCount = 1
        return Static.instance
    }


    // MARK: - Fields

    var delegate: ModelNetworkOperationDelegate?

    fileprivate var service: ServiceType
    fileprivate var parameters: NSDictionary?


    // MARK: - Constructor

    init(service: ServiceType, parameters:NSDictionary?) {

        self.service = service
        self.parameters = parameters
    }


    // MARK: - Overrride

    override func cancel() {
        super.cancel()

        self.delegate = nil
    }

    override func main() {

        // check internet connection

        if Reachability.isConnectedToNetwork() == false {
            sendFailureWithError(NSError(domain:"You seems not to be connected to Internet", code:-1, userInfo:nil))
            return
        }

        // define Url
        
        var stringUrl:String
        do {
            stringUrl = try ServiceAtlas.urlForService(self.service)!
        } catch let error1 as NSError {
            sendFailureWithError(error1)
            return
        }

        if parameters != nil {

            var isFirstParam = true
            for (key, value) in parameters! {

                if (isFirstParam)
                {
                    stringUrl = stringUrl + "?"
                    isFirstParam = false
                }
                else
                {
                    stringUrl = stringUrl + "&"
                }

                stringUrl = stringUrl + (key as! String) + "=\(value)"
            }
        }

        // send request

        let request:NSMutableURLRequest = NSMutableURLRequest(url: URL(string: stringUrl.addingPercentEscapes(using: String.Encoding.utf8)!)!)

        let uuid = UIDevice.current.identifierForVendor!.uuidString
        request.setValue(uuid, forHTTPHeaderField: "uuid")

        URLProtocol.setProperty("multipart/form-data", forKey: "Content-Type", in: request)

        request.httpMethod = ServiceAtlas.methodForService(self.service);

        var response: URLResponse?
        let data: Data?
        do {
            data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        } catch let error1 as NSError {
            sendFailureWithError(error1)
            return
        }

        // check response
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode < 200 || httpResponse.statusCode >= 400 {
                sendFailureWithError(NSError(domain:"Invalid status code", code:httpResponse.statusCode, userInfo:nil))
                return
            }
        }

        // parse model
        let model: AnyObject?
        do {
            model = try ServiceAtlas.parseModelForService(self.service, jsonData: data!)
        } catch let error1 as NSError {
            sendFailureWithError(error1)
            return
        }

        // store model
        let cachePath:String? = ServiceAtlas.cachePathForService(self.service, parameters: parameters)
        if cachePath != nil {
            CacheUtil.saveModel(model!, toFile: cachePath!)
        }

        // send successs
        sendSuccessWithModel(model!)
    }


    // MARK: - Delegate call

    fileprivate func sendSuccessWithModel(_ model: AnyObject) {
        DispatchQueue.main.sync(execute: {
            self.delegate?.modelNetworkOperation(self, didSucceedWithModel: model)
        })
    }

    fileprivate func sendFailureWithError(_ error: NSError) {
        DispatchQueue.main.sync(execute: {
            self.delegate?.modelNetworkOperation(self, didFailWithError: error)
        })
    }
}

