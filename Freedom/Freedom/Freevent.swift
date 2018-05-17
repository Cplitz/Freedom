//
//  Freedom.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 20/4/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//
//  This class represents information about a Freevent - an in-app reminder

import Foundation
import UIKit
import UserNotifications

class Freevent : NSObject, NSCoding {
    
    //MARK: Properties
    static var nFreevents = 0                   // Current number of created freevents
    
    var id : Int?                                // the freevent ID
    var freeName : String                       // name of the freevent
    var freeNotes : String                      // notes about the freevent
    var freeEndDate : Date                      // when the freevent should be considered overdue
    var freeReminderDate : Date                 // when the freevent should be considered 'upcoming' and a reminder is sent
    var freeImg: UIImage                        // the icon of the freevent
    var freeCategory : Category                 // the category the freevent belongs too
    var notification : UNNotificationRequest?   // the notification request tied to the freevent
    
    //MARK: Types
    // Used for encoding and decoding persistent data
    struct PropertyKey {
        static let name = "freeName"
        static let notes = "freeNotes"
        static let endDate = "freeEndDate"
        static let reminderDate = "freeReminderDate"
        static let img = "freeImg"
        static let category = "freeCategory"
    }
    
    // Class initialiser
    init(_ name : String,_ notes : String,_ endDate : Date,_ reminderDate : Date,_ category : Category,_ img : UIImage? = nil)
    {
        
        freeName = name
        freeNotes = notes
        freeEndDate = endDate
        freeReminderDate = reminderDate
        freeCategory = category
        if img == nil {
            freeImg = UIImage(named: "defaultFreeventImg")!
        }
        else {
            freeImg = img!
        }
        
        super.init()
        id = generateID()
        
        sendNotification()
    }
    
    // Generates a new freevent ID
    private func generateID() -> Int {
        Freevent.nFreevents += 1
        let newID : Int = Freevent.nFreevents
        return newID
    }
    
    // Converts a number of seconds into human readable format, displaying the first two non-zero units of time (e.g. 2 days, 0 hours, 0 minutes, 20 seconds displays as 2 days, 20 seconds)
    func readableTimeLeft() -> String {
        // get the time remaining
        let secondsToEnd : TimeInterval = freeEndDate.timeIntervalSinceNow
        
        // get the total number of each time unit
        let minutes : Double = secondsToEnd / 60
        let hours : Double = minutes / 60
        let days : Double = hours / 24
        let months: Double = days / 30
        let years : Double = days / 365
        
        // use the totals to calculate remainders (e.g. 2 hours, 30 minutes should NOT read as 2 hours, 150 minutes)
        let rSeconds = secondsToEnd.truncatingRemainder(dividingBy: 60)
        let rMinutes = minutes.truncatingRemainder(dividingBy: 60)
        let rHours = hours.truncatingRemainder(dividingBy: 24)
        let rDays = days.truncatingRemainder(dividingBy: 7)
        let rMonths = months.truncatingRemainder(dividingBy: 12)
        let rYears = years
        
        // Set the array of human readable unit words
        let strAppendages = ["year", "month", "day", "hour", "minute", "second"]
        
        // Set the array of reaminder units
        let units = [rYears, rMonths, rDays, rHours, rMinutes, rSeconds]
        
        // Initialse the array which will hold the unit strings to display
        var displayUnits  = [String]()
        
        // Iterate through each unit
        for idx in 0...units.count - 1 {
            
            // Round the unit value
            var quantity : Int
            if units[idx] < 0 {
                quantity = Int(ceil(units[idx]))
            }
            else {
                quantity = Int(floor(units[idx]))
            }
            
            // If the floored unit value is not 0, add it to the displayUnits array
            if quantity != 0 {
                
                // This simply converts "1.3222" to 1 hour (for example), and adds a plural 's' if the quantity is greater than 1
                displayUnits.append("\(quantity) \(strAppendages[idx])\(abs(quantity) > 1 ? "s" : "")")
                
                // If this is the second unit added to the displayUnits array, break from the loop
                if displayUnits.count == 2 {
                    break
                }
            }
        }
        
        // Determine if overdue or not
        let overdueStr = secondsToEnd <= 0 ? "OVERDUE:\n" : ""
        
        // join the strings in the array using the separator ", "
        return overdueStr + displayUnits.joined(separator: ", ")
        
    }
    
    //MARK: Notification handling
    private func scheduleReminderNotification() {
        // Setup the notification's content
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Reminder: \(freeName)  Freevent due soon", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Category: \(freeCategory.catName)",
            arguments: nil)
        content.sound = UNNotificationSound.default()
        
        
        // Configure the trigger to deliver the notification on the reminder date
        let components : Set<Calendar.Component> = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute]
        let triggerDate = Calendar.current.dateComponents(components, from: freeReminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Create the request object
        let request = UNNotificationRequest(identifier: "freevent\(id!)", content: content, trigger: trigger)
        self.notification = request
        
        // Schedule the request for delivery
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    // Get notification authorization status
    private func sendNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus == .authorized else {return}
            
            if settings.alertSetting == .enabled {
                // Schedule an alert-only notification.
                self.scheduleReminderNotification()
            }
        }
    }
    
    // MARK: - NSCoding
    // Encodes the freevent data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(freeName, forKey: PropertyKey.name)
        aCoder.encode(freeNotes, forKey: PropertyKey.notes)
        aCoder.encode(freeEndDate, forKey: PropertyKey.endDate)
        aCoder.encode(freeReminderDate, forKey: PropertyKey.reminderDate)
        aCoder.encode(freeImg, forKey: PropertyKey.img)
        aCoder.encode(freeCategory, forKey: PropertyKey.category)
    }
    
    // Decodes the freevent data and creates an instance of a Freevent using that data
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            fatalError("The name could not be decoded")
        }
        guard let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String else {
            fatalError("The notes could not be decoded")
        }
        guard let endDate = aDecoder.decodeObject(forKey: PropertyKey.endDate) as? Date else {
            fatalError("The end date could not be decoded")
        }
        guard let reminderDate = aDecoder.decodeObject(forKey: PropertyKey.reminderDate) as? Date else {
            fatalError("The reminder date could not be decoded")
        }
        let img = aDecoder.decodeObject(forKey: PropertyKey.name) as? UIImage
        guard let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? Category else {
            fatalError("The category could not be decoded")
        }
        
        self.init(name, notes, endDate, reminderDate, category, img)
    }
}



