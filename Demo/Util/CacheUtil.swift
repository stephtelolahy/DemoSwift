//
//  CacheUtil.swift
//  Demo
//
//  Created by Telolahy on 30/05/16.
//  Copyright © 2016 CreativeGames. All rights reserved.
//

import UIKit

class CacheUtil: AnyObject {

    static func makePathLink(_ folderName: String, fileName: String)->String? {

        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDirUrl = URL(fileURLWithPath: dirPaths[0])
        let newDirUrl = docsDirUrl.appendingPathComponent(folderName)

        // create directory if needed
        do {
            try  FileManager.default.createDirectory(at: newDirUrl, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Failed to create dir: \(error.localizedDescription)")
            return nil
        }

        let filePath = newDirUrl.appendingPathComponent(fileName).path

        return filePath
    }

    static func saveModel(_ object:AnyObject, toFile filePath: String) -> Bool {

        return NSKeyedArchiver.archiveRootObject(object, toFile: filePath)
    }

    static func loadModel(_ filePath: String) throws -> AnyObject {

        if FileManager.default.fileExists(atPath: filePath) == false {
            throw NSError(domain:"File not found: \(filePath)", code:-1, userInfo:nil)
        }

        let object: AnyObject? = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as AnyObject
        if object == nil {
            throw NSError(domain:"Cannot unarchive file", code:1, userInfo:nil);
        }

        return object!;
    }

    static func deleteFile(_ filePath: String)->Bool{
        do {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        } catch _ {
            return false
        }
    }

}
