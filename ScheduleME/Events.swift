//
//  Events.swift
//  ScheduleME
//
//  Created by ranjay on 3/25/16.
//  Copyright © 2016 ranjay. All rights reserved.
//

import UIKit
import Foundation

class Events: NSObject {

    var title: String?
    var date: String?
    
    init(title:String, date:String) {
        
         super.init();
        self.title = title;
        self.date = date;
       
    }
}
