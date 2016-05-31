//
//  AppConfig.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class AppConfig: AnyObject {

    static var serverRootUrl = "http://176.31.187.49:8888/boky"

    static var availableStores: Array<Store>?

    static var currentUser: User?

    static func currentStore() -> Store {
        return availableStores![0] as Store
    }
}
