//
//  ServiceAtlas.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit


enum ServiceType {

    case ServiceUser
}

class ServiceAtlas: AnyObject {

    static func urlForService(service: ServiceType) throws -> String? {

        var apiUrl: String

        switch service {

        case .ServiceUser:
            apiUrl = "/api/v1/compte/1/login.json"
            break

        default:
            throw NSError(domain:"Unsupported service: \(service)", code:-1, userInfo:nil)
        }

        // concat API url with rootUrl
        let serviceUrl = String(format: "%@%@", AppConfig.serverRootUrl, apiUrl)

        return serviceUrl
    }

    static func methodForService(service: ServiceType)->String {
        var apiMethod: String

        switch service {

        default:
            apiMethod = "GET"
        }

        return apiMethod;
    }

    static func cachePathForService(service: ServiceType, parameters : NSDictionary?) -> String? {

        switch service {

        case .ServiceUser:
            return CacheUtil.makePathLink("userData", fileName: "user")

        default:
            // return nil to not save model
            return nil
        }
    }

    static func parseModelForService(service: ServiceType, jsonData:NSData) throws -> AnyObject {
        switch service {

        case .ServiceUser:
            return try User.parseUserFromJsonData(jsonData)

        default:
            if let jsonDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                return jsonDictionary
            }
            throw NSError(domain:"Unsupported service: \(service)", code:-1, userInfo:nil)
        }
    }

}
