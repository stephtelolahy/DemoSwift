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

        self.id = decoder.decodeObject(forKey: Store.KEY_STORE_ID) as! Int
        self.name = decoder.decodeObject(forKey: Store.KEY_STORE_NAME) as! String
        self.flagUrl = decoder.decodeObject(forKey: Store.KEY_STORE_FLAG_URL) as! String
    }

    func encode(with coder: NSCoder) {

        coder.encode(self.id, forKey: Store.KEY_STORE_ID)
        coder.encode(self.name, forKey: Store.KEY_STORE_NAME)
        coder.encode(self.flagUrl, forKey: Store.KEY_STORE_FLAG_URL)
    }

    // MARK: - JSON Parsing

    static func parseStoreFromJsonDictionary(_ jsonDictionary: NSDictionary) throws -> Store {

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

    static func parseStoresFromJsonData(_ jsonData: Data) throws -> Array<Store> {

        let jsonArray = (try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray

        var stores = Array<Store>()

        for jsonElement in jsonArray {

            let store = try Store.parseStoreFromJsonDictionary(jsonElement as! NSDictionary)
            stores.append(store)
        }

        return stores
    }

    
}
