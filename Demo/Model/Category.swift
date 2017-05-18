//
//  Category.swift
//  Demo
//
//  Created by Telolahy on 31/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class Category: NSObject, NSCoding {


    // MARK: - Constants

    static let KEY_CATEGORY_ID = "idcategorie"
    static let KEY_CATEGORY_NAME = "libelle"
    static let KEY_CATEGORY_THUMBS_URL = "vignette"
    static let KEY_CATEGORY_STORE_ID = "idstore"
    

    // MARK: - Fields

    var id: Int!
    var name: String!
    var thumbsUrl : String!


    // MARK: NSCoding

    required convenience init?(coder decoder: NSCoder) {
        self.init()

        self.id = decoder.decodeObject(forKey: Category.KEY_CATEGORY_ID) as! Int
        self.name = decoder.decodeObject(forKey: Category.KEY_CATEGORY_NAME) as! String
        self.thumbsUrl = decoder.decodeObject(forKey: Category.KEY_CATEGORY_THUMBS_URL) as! String
    }

    func encode(with coder: NSCoder) {

        coder.encode(self.id, forKey: Category.KEY_CATEGORY_ID)
        coder.encode(self.name, forKey: Category.KEY_CATEGORY_NAME)
        coder.encode(self.thumbsUrl, forKey: Category.KEY_CATEGORY_THUMBS_URL)
    }


    // MARK: - JSON Parsing

    static func parseCategoryFromJsonDictionary(_ jsonDictionary: NSDictionary) throws -> Category {

        let category = Category()

        if let id: Int = jsonDictionary[Category.KEY_CATEGORY_ID] as? Int {
            category.id = id
        }

        if let name: String = jsonDictionary[Category.KEY_CATEGORY_NAME] as? String {
            category.name = name
        }
        
        if let thumbsUrl: String = jsonDictionary[Category.KEY_CATEGORY_THUMBS_URL] as? String {
            category.thumbsUrl = thumbsUrl
        }

        return category
    }

    static func parseCategoriesFromJsonData(_ jsonData: Data) throws -> Array<Category> {

        let jsonArray = (try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray

        var categories = Array<Category>()

        for jsonElement in jsonArray {

            let category = try Category.parseCategoryFromJsonDictionary(jsonElement as! NSDictionary)
            categories.append(category)
        }

        return categories
    }

}
