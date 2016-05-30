//
//  CacheUtil.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class CacheUtil: AnyObject {

    static func makePathLink(folderName: String, fileName: String)->String? {

        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDirUrl = NSURL(fileURLWithPath: dirPaths[0])
        let newDirUrl = docsDirUrl.URLByAppendingPathComponent(folderName)

        // create directory if needed
        do {
            try  NSFileManager.defaultManager().createDirectoryAtURL(newDirUrl, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Failed to create dir: \(error.localizedDescription)")
            return nil
        }

        let filePath = newDirUrl.URLByAppendingPathComponent(fileName).path

        return filePath
    }

    static func saveModel(object:AnyObject, toFile filePath: String) -> Bool {

        return NSKeyedArchiver.archiveRootObject(object, toFile: filePath)
    }

    static func loadModel(filePath: String) throws -> AnyObject {

        if NSFileManager.defaultManager().fileExistsAtPath(filePath) == false {
            throw NSError(domain:"File not found: \(filePath)", code:-1, userInfo:nil)
        }

        let object: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath)
        if object == nil {
            throw NSError(domain:"Cannot unarchive file", code:1, userInfo:nil);
        }

        return object!;
    }

    static func deleteFile(filePath: String)->Bool{
        do {
            try NSFileManager.defaultManager().removeItemAtPath(filePath)
            return true
        } catch _ {
            return false
        }
    }

}
