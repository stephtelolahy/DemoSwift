//
//  Store.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class Store: NSObject, NSCoding {

    // MARK: Constants

    static let KEY_STORE_ID = "idpays"
    static let KEY_STORE_NAME = "nom"
    static let KEY_STORE_FLAG_URL = "drapeau"

    // MARK: - Fields

    var id: Int!
    var name: String!
    var flagUrl: String!

    // MARK: NSCoding

    required convenience init?(coder decoder: NSCoder) {
        self.init()

        self.id = decoder.decodeObjectForKey(Store.KEY_STORE_ID) as! Int
        self.name = decoder.decodeObjectForKey(Store.KEY_STORE_NAME) as! String
        self.flagUrl = decoder.decodeObjectForKey(Store.KEY_STORE_FLAG_URL) as! String
    }

    func encodeWithCoder(coder: NSCoder) {

        coder.encodeObject(self.id, forKey: Store.KEY_STORE_ID)
        coder.encodeObject(self.name, forKey: Store.KEY_STORE_NAME)
        coder.encodeObject(self.flagUrl, forKey: Store.KEY_STORE_FLAG_URL)
    }

    // MARK: - JSON Parsing

    static func parseStoreFromJsonDictionary(jsonDictionary: NSDictionary) throws -> Store {

        let store = Store()

        if let id: Int = jsonDictionary[Store.KEY_STORE_ID] as? Int {
            store.id = id
        }

        if let name: String = jsonDictionary[Store.KEY_STORE_NAME] as? String {
            store.name = name
        }
        
        if let flagUrl: String = jsonDictionary[Store.KEY_STORE_FLAG_URL] as? String {
            store.flagUrl = flagUrl
        }

        return store
    }

    static func parseStoresFromJsonData(jsonData: NSData) throws -> Array<Store> {

        let jsonArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)) as! NSArray

        var stores = Array<Store>()

        for jsonElement in jsonArray {

            let store = try Store.parseStoreFromJsonDictionary(jsonElement as! NSDictionary)
            stores.append(store)
        }

        return stores
    }

    
}
