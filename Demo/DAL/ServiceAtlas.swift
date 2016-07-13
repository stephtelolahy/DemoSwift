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
            let storeId: Int = parameters![Category.KEY_CATEGORY_STORE_ID] as! Int
            let fileName = String(format: "categories-%d", storeId)
            return CacheUtil.makePathLink("commonData", fileName: fileName)
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
        }
    }

}
