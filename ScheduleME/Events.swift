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
    var calendar: [AnyObject]?
    
    init(title:String, date:String, calendar:[AnyObject]) {
        
         super.init();
        self.title = title;
        self.date = date;
        self.calendar = calendar
        
       
    }
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "title" : "title",
            "date" : "date",
            "calendar": "calendar",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }
}
