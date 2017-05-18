//
//  ServiceAtlas.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit


enum ServiceType {

    case serviceUser
    case serviceStores
    case serviceCategories
}

class ServiceAtlas: AnyObject {

    static func urlForService(_ service: ServiceType) throws -> String? {

        var apiUrl: String

        switch service {

        case .serviceUser:
            apiUrl = "/api/v1/compte/1/login.json"
            break

        case .serviceStores:
            apiUrl = "/api/v1/store.json"
            break

        case .serviceCategories:
            apiUrl = "/api/v1/categorie.json"
            break
        }

        // concat API url with rootUrl
        let serviceUrl = String(format: "%@%@", AppConfig.serverRootUrl, apiUrl)

        return serviceUrl
    }

    static func methodForService(_ service: ServiceType)->String {
        var apiMethod: String

        switch service {

        default:
            apiMethod = "GET"
        }

        return apiMethod;
    }

    static func cachePathForService(_ service: ServiceType, parameters : NSDictionary?) -> String? {

        switch service {

        case .serviceUser:
            return CacheUtil.makePathLink("userData", fileName: "user")

        case .serviceStores:
            return CacheUtil.makePathLink("commonData", fileName: "stores")

        case .serviceCategories:
            let storeId: Int = parameters![Category.KEY_CATEGORY_STORE_ID] as! Int
            let fileName = String(format: "categories-%d", storeId)
            return CacheUtil.makePathLink("commonData", fileName: fileName)
        }
    }

    static func parseModelForService(_ service: ServiceType, jsonData:Data) throws -> AnyObject {
        switch service {

        case .serviceUser:
            return try User.parseUserFromJsonData(jsonData)

        case .serviceStores:
            return try Store.parseStoresFromJsonData(jsonData) as AnyObject

        case .serviceCategories:
            return try Category.parseCategoriesFromJsonData(jsonData) as AnyObject
        }
    }

}
