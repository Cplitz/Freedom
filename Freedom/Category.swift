//
//  Category.swift
//  Freedom
//
//  Created by user137759 on 5/4/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import Foundation
import UIKit

class Category : NSObject {
    var catName : String?
    var numUpcoming : UInt32?
    //var catEditButton : UIButton?
    //var catDelButton : UIButton?
    var catImg: UIImage?
    var freevents = [Freevent]()
    
    init(_ name : String,_ upcoming : UInt32,/*_ editButton : UIButton,_ delButton : UIButton,*/_ img : UIImage? = nil) {
        catName = name
        numUpcoming = upcoming
        //catEditButton = editButton
        //catDelButton = delButton
        
        if img == nil {
            catImg = UIImage(named: "defaultCategoryImg")
        }
        else {
            catImg = img
        }
        
        super.init()
    }
    
    
    func getFreevents() -> [Freevent] {
        if freevents.count == 0 { loadFreevents() }
        return freevents
    }
    
    func addFreevent(_ name : String,_ editButton : UIButton,_ delButton : UIButton,_ img : UIImage,_ notes : String,_ endDate : Date,_ reminderDate : Date,_ category : Category? = nil) {
        
    }
    
    func getFreevent(at : Int) -> Freevent? {
        if freevents.count == 0 { loadFreevents() }
        
        if at >= 0 && at < freevents.count {
            return freevents[at]
        }
        return nil
    }
    func loadFreevents() {
        if freevents.count == 0 {
            
            //Add a trip to Melbourne
            //trips.append ( Freevent("Melbourne", 3 , "2018/10/10", UIImage(named : "Melbourne")!))
            
            //trips.append ( Freevent("Sydney", 13, "2018/08/10", UIImage(named : "Sydney")!))
            
            //trips.append (Freevent("Adelaide", 10, "2017/08/10", UIImage(named : "Adelaide")!))
            
        }
        
    }
    
    
}

class Categories {
    static var categories = [Category]()
    
    static func getCategories() -> [Category] {
        if categories.count == 0 { loadCategories() }
        return categories
    }
    
    static func addCategory(_ name : String,_ upcoming : UInt32,_ editButton : UIButton,_ delButton : UIButton,_ img : UIImage? = nil) {
        
    }
    
    static func getCategory(at : Int) -> Category? {
        if categories.count == 0 { loadCategories() }
        
        if at >= 0 && at < categories.count {
            return categories[at]
        }
        return nil
    }
    static func loadCategories() {
        if categories.count == 0 {
            
            //Add a trip to Melbourne
            categories.append ( Category("Testing", 2, UIImage(named: "freevent1")!) )
            
            categories.append ( Category("Testing1", 2, UIImage(named: "freevent2")!) )
            
            categories.append ( Category("Testing2", 2, UIImage(named: "freevent3")!) )
            
            categories.append ( Category("Uncategorized", 0) )
            
        }
        
    }
}

