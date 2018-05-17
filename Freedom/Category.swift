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
    
    //MARK: Properties
    var catName : String           // the name of the category
    var numUpcoming : Int = 0       // the number of upcoming freevents in the category
    var catImg: UIImage?            // the category's icon
    var freevents = [Freevent]()    // the list of freevents in the category
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("categories")
    
    //MARK: Types
    // Used for encoding and decoding persistent data
    struct PropertyKey {
        static let name = "catName"
        static let img = "catImg"
        static let freevents = "freevents"
    }
    
    // Class initialiser
    init(_ name : String,_ img : UIImage? = nil, _ initFreevents : [Freevent] = [Freevent]()) {
        catName = name
        if img == nil {
            catImg = UIImage(named: "defaultCategoryImg")
        }
        else {
            catImg = img
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
    
    // Decodes the class data and initialises a new Category object with that dataz
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            fatalError("Failed to decode name")
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.img) as? UIImage
        guard let freevents = aDecoder.decodeObject(forKey: PropertyKey.freevents) as? [Freevent] else {
            fatalError("Failed to decode freevents")
            return nil
        }
        
        self.init(name, photo, freevents)
    }
}

// Class representing all of the stored categories in the application
class Categories {
    static var categories = [Category]()                    // The list of categories
    static var upcoming : Category = Category("Upcoming")   // The upcoming category
    
    // Adds a new category at specified index 'at'
    static func addCategory(_ category : Category, at : Int? = nil) {
        // Determine the last index in the array if at is not sepcified
        var idx : Int
        if at == nil {
            idx = (Categories.categories.count - 1) >= 0 ? Categories.categories.count - 1 : 0
        }
        else {
            idx = at!
        }
        
        if idx > 0 && idx < Categories.categories.count {
            Categories.categories.insert(category, at: idx)
        }
        else {
            Categories.categories.append(category)
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
    
    // Calculates the freevents which are upcoming and adds them to the upcoming category
    static func calculateUpcoming() {
        Categories.upcoming.freevents = []
        for category in Categories.categories {
            category.calculateUpcoming()
        }
    }
    
    // sample categories
    static func loadSampleCategories() {
        if categories.count == 0 {
            
            categories.append ( Category("Testing", UIImage(named: "freevent1")!) )
            
            categories.append ( Category("Testing1", UIImage(named: "freevent2")!) )
            
            categories.append ( Category("Testing2", UIImage(named: "freevent3")!) )
            
        }
    }
    
    // Saves the current list of categories
    static func saveCategories() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(Categories.categories, toFile: Category.ArchiveURL.path)
        print(isSuccessfulSave)
    }
    
    // Loads the saved list of categories
    static func loadCategories() -> [Category]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Category.ArchiveURL.path) as? [Category]
    }
    
}



