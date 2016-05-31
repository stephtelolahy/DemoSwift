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
    case ServiceStores
    case ServiceCategories
}

class ServiceAtlas: AnyObject {

    static func urlForService(service: ServiceType) throws -> String? {

        var apiUrl: String

        switch service {

        case .ServiceUser:
            apiUrl = "/api/v1/compte/1/login.json"
            break

        case .ServiceStores:
            apiUrl = "/api/v1/store.json"
            break

        case .ServiceCategories:
            apiUrl = "/api/v1/categorie.json"
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

        case .ServiceStores:
            return CacheUtil.makePathLink("commonData", fileName: "stores")

        case .ServiceCategories:
            return CacheUtil.makePathLink("commonData", fileName: "categories")

        default:
            // return nil if you don't want to cache model
            return nil
        }
    }

    static func parseModelForService(service: ServiceType, jsonData:NSData) throws -> AnyObject {
        switch service {

        case .ServiceUser:
            return try User.parseUserFromJsonData(jsonData)

        case .ServiceStores:
            return try Store.parseStoresFromJsonData(jsonData)

        case .ServiceCategories:
            return try Category.parseCategoriesFromJsonData(jsonData)

        default:
            throw NSError(domain:"Unsupported service: \(service)", code:-1, userInfo:nil)
        }
    }

}
