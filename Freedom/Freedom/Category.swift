//
//  Category.swift
//  Freedom
//
//  Created by user137759 on 5/4/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import Foundation

class Category : NSObject {
    var catName : String?
    var numUpcoming : UInt32?
    var catEditButton : UIButton?
    var catDelButton : UIButton?
    var catImg: UIImage?
    var catFreevents : Freevents?
    
    init(_ name : String,_ upcoming : UInt32,_ editButton : UIButton,_ delButton : UIButton,_ img = UIImage,_ freevents : Freevents) {
        catName = name
        numUpcoming = upcoming
        catEditButton = editButton
        catDelButton = delButton
        catImg = img
        catFreevents = freevents
        
        super.init()
    }

    
}

class Categories {
    static var categories = [Category]()
    
    static func getCategories() -> [Category] {
        if categories.count == 0 { loadCategories() }
        return categories
    }
    
    static func addCategory(_ name : String,_ upcoming : UInt32,_ editButton : UIButton,_ delButton : UIButton,_ img = UIImage,_ freevents : Freevents) {
        
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
            //categories.append ( Freevent("Melbourne", 3 , "2018/10/10", UIImage(named : "Melbourne")!))
            
            //categories.append ( Freevent("Sydney", 13, "2018/08/10", UIImage(named : "Sydney")!))
            
            c//ategories.append ( Freevent("Adelaide", 10, "2017/08/10", UIImage(named : "Adelaide")!))
            
        }
        
    }
}
