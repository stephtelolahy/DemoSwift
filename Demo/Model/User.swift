//
//  User.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {

    // MARK: Constants

    static let KEY_USERNAME = "username"
    static let KEY_PASSOWRD = "password"


    // MARK: - Fields

    var username: String!
    var password: String!

    // MARK: NSCoding

    required convenience init?(coder decoder: NSCoder) {
        self.init()

        self.username = decoder.decodeObjectForKey(User.KEY_USERNAME) as! String
        self.password = decoder.decodeObjectForKey(User.KEY_PASSOWRD) as! String
    }

    func encodeWithCoder(coder: NSCoder) {

        coder.encodeObject(self.username, forKey: User.KEY_USERNAME)
        coder.encodeObject(self.password, forKey: User.KEY_PASSOWRD)
    }

    // MARK: - JSON Parsing

    static func parseUserFromJsonData(jsonData: NSData) throws -> User {

        let jsonDictionary: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary

        let user = User()

        if let username: AnyObject = jsonDictionary[User.KEY_USERNAME] {
            user.username = username as! String
        }

        if let password: AnyObject = jsonDictionary[User.KEY_PASSOWRD] {
            user.password = password as! String
        }

        return user
    }



}
