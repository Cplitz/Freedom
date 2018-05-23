//
//  Category.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/4/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//
//  This class represents a category in the app - it holds a number of Freevents

import Foundation
import UIKit
import UserNotifications

class Category : NSObject, NSCoding {
    static var supportsSecureCoding: Bool { get {return true} }
    
    
    
    
    //MARK: Properties
    var catName : String            // the name of the category
    var numUpcoming : Int = 0       // the number of upcoming freevents in the category
    var catImg: UIImage            // the category's icon
    var freevents = [Freevent]()    // the list of freevents in the category
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("categories")
    
    //MARK: Types
    // Used for encoding and decoding data
    struct PropertyKey  {
        static let name = "freeName"
        static let img = "freeImg"
        static let freevents = "freevents"
    }

    
    // Class initialiser
    init(_ name : String,_ img : UIImage? = nil, _ initFreevents : [Freevent] = [Freevent]()) {
        
        catName = name
        if img == nil {
            catImg = UIImage(named: "defaultCategoryImg")!
        }
        else {
            catImg = img!
        }
        
        freevents = initFreevents
        
        super.init()
    }
    
    
    
    // Calculates and returns the number of upcoming freevents in the category
    @discardableResult func calculateUpcoming() -> Int {
        numUpcoming = 0
        
        // Iterate through each freevent and determine if they are upcoming or not
        for f in freevents {
            // Get the time difference
            let diff : TimeInterval = f.freeReminderDate.timeIntervalSinceNow
            
            // Add to numUpcoming if it is passed the reminder date
            if diff < 0
            {
                numUpcoming += 1
                
                // Avoid adding duplicates if the freevent already exists in Upcoming
                var match = false
                for uFreevent in Categories.upcoming.freevents {
                    if uFreevent == f {
                        match = true
                        break
                    }
                }
                
                // Add the freevent to the upcoming category
                if !match { Categories.upcoming.addFreevent(f) }
            }
        }
        
        return numUpcoming
    }
    
    // Swaps the position of two freevents in the category
    private func swapFreevents(_ idx1 : Int,_ idx2 : Int) {
        let temp = freevents[idx1]
        freevents[idx1] = freevents[idx2]
        freevents[idx2] = temp
    }
    
    // Orders the freevents by date to display the soonest ending freevent at the top
    func orderByDate() {
        // Already ordered
        if freevents.count <= 1 {
            return
        }
        
        // Bubble sort
        for _ in 0...freevents.count - 1
        {
            for j in 0...freevents.count - 2
            {
                let diff : TimeInterval = (freevents[j].freeEndDate.timeIntervalSince(freevents[j + 1].freeEndDate))
                if (diff > 0)
                {
                    swapFreevents(j, j + 1);
                }
            }
        }
    }
    
    // Adds a freevent and then ensures it is in the correct order
    func addFreevent(_ freevent : Freevent) {
        freevents.append(freevent)
        orderByDate()
    }
    
    // Retrieves a freevent at a given index
    func getFreevent(at : Int) -> Freevent? {
        if at >= 0 && at < freevents.count {
            return freevents[at]
        }
        return nil
    }
    
    //MARK: NSCoding
    // Encodes the class data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(catName, forKey: PropertyKey.name)
        aCoder.encode(catImg, forKey: PropertyKey.img)
        aCoder.encode(freevents, forKey: PropertyKey.freevents)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            //fatalError("Unable to decode name")
            return nil
        }
        guard let img = aDecoder.decodeObject(forKey: PropertyKey.img) as? UIImage else {
            //fatalError("Unable to decode img")
            return nil
        }
        guard let freevents = aDecoder.decodeObject(forKey: PropertyKey.freevents) as? [Freevent] else {
            //fatalError("Unable to decode freevents")
            return nil
        }
        
        self.init(name, img, freevents)
    }

}

// Class representing all of the stored categories in the application
class Categories {
    static var categories = [Category]()                    // The list of categories
    static var upcoming : Category = Category("Upcoming")   // The upcoming category
    
    // Swaps the position of two categproes in the category
    private static func swapCategories(_ idx1 : Int,_ idx2 : Int) {
        let temp = categories[idx1]
        categories[idx1] = categories[idx2]
        categories[idx2] = temp
    }
    
    // Adds a new category
    static func addCategory(_ category : Category) {
        // Add category to array
        Categories.categories.append(category)
        
        // Check if uncategorized category exists
        if let _ = getCategory(named: "Uncategorized") {
            // If the category being added is not the uncategorized category, swap them to ensure uncategorized is last
            if category.catName != "Uncategorized" {
                swapCategories(Categories.categories.count - 1, Categories.categories.count - 2)
            }
        }

        
        
    }
    
    // Returns a category at the specified index
    static func getCategory(at : Int) -> Category? {
        if at >= 0 && at < categories.count {
            return categories[at]
        }
        return nil
    }
    
    // Returns a category with the specified name
    static func getCategory(named: String) -> Category? {
        for cat in categories {
            if cat.catName == named {
                return cat
            }
        }
        return nil
    }
    
    static func getNumFreevents() -> Int {
        var numFreevents = 0
        for cat in categories {
            numFreevents += cat.freevents.count
        }
        return numFreevents
    }
    
    static func getFreevent(withID : Int) -> Freevent? {
        for cat in categories {
            for f in cat.freevents {
                if f.freeID == withID {
                    return f
                }
            }
        }
        return nil
    }
    
    // Calculates the freevents which are upcoming and adds them to the upcoming category
    @discardableResult
    static func calculateUpcoming() -> Int {
        var num = 0
        Categories.upcoming.freevents = []
        for category in Categories.categories {
            num += category.calculateUpcoming()
        }
        return num
    }
    
    // sample categories
    static func loadSampleCategories() {
        if categories.count == 0 {
            
            categories.append ( Category("School", UIImage(named: "schoolFreevent")!) )
            
            categories.append ( Category("Work", UIImage(named: "workFreevent")!) )
            
            categories.append ( Category("Uncategorized", UIImage(named: "defaultCategoryImg")!) )
            
        }
    }
    
    
    
    // Saves the current list of categories
    static func saveCategories() {
        NSKeyedArchiver.archiveRootObject(Categories.categories, toFile: Category.ArchiveURL.path)
    }
    
    // Loads the saved list of categories
    static func loadCategories() -> [Category]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Category.ArchiveURL.path) as? [Category]
    }
    
}



