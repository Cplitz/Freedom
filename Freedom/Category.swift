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
    var numUpcoming : Int
    //var catEditButton : UIButton?
    //var catDelButton : UIButton?
    var catImg: UIImage?
    var freevents = [Freevent]()
    
    init(_ name : String,_ img : UIImage? = nil) {
        catName = name
        numUpcoming = 0
        
        if img == nil {
            catImg = UIImage(named: "defaultCategoryImg")
        }
        else {
            catImg = img
        }
        
        super.init()
    }
    
    func calculateUpcoming() -> Int {
        numUpcoming = 0
        Categories.upcoming.freevents = []
        for f in freevents {
            let diff : TimeInterval = f.freeReminderDate!.timeIntervalSinceNow
            if diff < 0 {
                numUpcoming += 1
                
                var match = false
                for uFreevent in Categories.upcoming.freevents {
                    if uFreevent == f {
                        match = true
                        break
                    }
                }
                
                if !match { Categories.upcoming.addFreevent(f) }
            }
        }
        return numUpcoming
    }
    
    func getFreevents() -> [Freevent] {
        if freevents.count == 0 { loadFreevents() }
        return freevents
    }
    
    private func swapFreevents(_ idx1 : Int,_ idx2 : Int) {
        let temp = freevents[idx1]
        freevents[idx1] = freevents[idx2]
        freevents[idx2] = temp
    }
    
    func orderByDate() {
        if freevents.count <= 1 {
            return
        }
        for _ in 0...freevents.count - 1
        {
            for j in 0...freevents.count - 2
            {
                let diff : TimeInterval = (freevents[j].freeEndDate?.timeIntervalSince(freevents[j + 1].freeEndDate!))!
                if (diff > 0)
                {
                    swapFreevents(j, j + 1);
                }
            }
        }
    }
    
    func addFreevent(_ freevent : Freevent) {
        freevents.append(freevent)
        orderByDate()
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
    static var upcoming : Category = Category("Upcoming")
    
    static func getCategories() -> [Category] {
        if categories.count == 0 { loadCategories() }
        return categories
    }
    
    static func addCategory(_ category : Category) {
        
    }
    
    static func getCategory(at : Int) -> Category? {
        if categories.count == 0 { loadCategories() }
        
        if at >= 0 && at < categories.count {
            return categories[at]
        }
        return nil
    }
    
    static func getCategory(named: String) -> Category? {
        for cat in categories {
            if cat.catName == named {
                return cat
            }
        }
        return nil
    }
    
    static func loadCategories() {
        if categories.count == 0 {
            
            //Add a trip to Melbourne
            categories.append ( Category("Testing", UIImage(named: "freevent1")!) )
            
            categories.append ( Category("Testing1", UIImage(named: "freevent2")!) )
            
            categories.append ( Category("Testing2", UIImage(named: "freevent3")!) )
            
        }
        
    }
}



