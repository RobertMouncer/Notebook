//
//  Pinger.swift
//  noteBook
//
//  Created by rdm10 on 11/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit

//https://stackoverflow.com/a/52518310 is used here as it shows how to ping a website and
// check for a response

class Pinger: NSObject {
    let url: String
    
    override init() {
    self.url = "https://content.guardianapis.com/search?api-key=cb9a43af-3974-482a-8399-1ce3b9af475e"
    }
    
    func pingHost(completionHandler: @escaping (Bool?)->()) {
        var request = URLRequest(url: URL(string: self.url)!)
            request.httpMethod = "HEAD"
            
            URLSession(configuration: .default)
                .dataTask(with: request) { (_, response, error) -> Void in
                    guard error == nil else {
                        print("Error:", error ?? "")
                        completionHandler(false)
                        return
                    }
                    
                    guard (response as? HTTPURLResponse)?
                        .statusCode == 200 else {
                            print("down")
                            completionHandler(false)
                            return
                    }
                    
                    completionHandler(true)
                }
                .resume()
        
    }
}
