//
//  LoginManager.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

protocol LoginManagerDelegate {

    func loginManager(manager: LoginManager, didSucceedWithUser user:User)

    func loginManager(manager: LoginManager, didFailWithError error:NSError)
}

class LoginManager: AnyObject {

}
