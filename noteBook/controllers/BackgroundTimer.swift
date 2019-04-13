//
//  BackgroundTimer.swift
//  noteBook
//
//  Created by rdm10 on 13/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import Foundation
class BackGroundtimer {
    var timer:Timer!
    
    var helloWorldTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)

    
    @objc func sayHello()
    {
        NSLog("hello World")
    }

}
