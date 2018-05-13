//
//  Freedom.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 20/4/18.
//  Copyright © 2018 Deakin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import CoreData


class Freevent : NSObject {
    var freeName : String?
    var freeImg: UIImage?
    var freeNotes : String?
    var freeEndDate : Date?
    var freeReminderDate : Date?
    var freeCategory : Category?
    
    init(_ name : String,_ notes : String,_ endDate : Date,_ reminderDate : Date,_ img : UIImage? = nil,_ category : Category? = nil)
    {
        freeName = name
        freeNotes = notes
        freeEndDate = endDate
        freeReminderDate = reminderDate
        freeCategory = category
        if img == nil {
            freeImg = UIImage(named: "defaultFreeventImg")
        }
        else {
            freeImg = img
        }
        
        super.init()
    }
}



