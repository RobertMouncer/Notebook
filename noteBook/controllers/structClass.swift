//
//  structClass.swift
//  noteBook
//
//  Created by rdm10 on 10/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
enum Key:String {
    case data = "data"

}
public class structClass: NSObject, Codable {//NSCoding {
   
    let data: GuardianOpenPlatformData
    
    init(data: GuardianOpenPlatformData) {
        
        self.data = data
        
    }
    
//    public func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.data, forKey: "data")
//    }
//
//    public required convenience init?(coder aDecoder: NSCoder) {
//        let data = aDecoder.decodeObject(forKey: Key.data.rawValue) as! GuardianOpenPlatformData
//        self.init(data: data)
//    }
}
