//
//  TabBarViewController.swift
//  noteBook
//
//  Created by rdm10 on 13/04/2019.
//  Copyright © 2019 rdm10. All rights reserved.
//

import UIKit
import Foundation

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now(), repeating: 60)
        t.setEventHandler(handler: { [weak self] in
            // called every so often by the interval we defined above
            print("hello")
        })
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
