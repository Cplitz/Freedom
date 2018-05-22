//
//  AppDelegate.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 4/19/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Load saved categories
        if let savedCategories = Categories.loadCategories() {
            Categories.categories += savedCategories
        }
        else {
            Categories.loadSampleCategories()
        }
        
        // Request for user permission to send notifications (this is only prompted once and saved by the system)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound])
        {
            (granted, error) in
            // Enable or disable notifications based on authorization.
            
            if granted  { Freevent.notificationsEnabled = true }
            else        { Freevent.notificationsEnabled = false }
        }

        // Define Actions
        let rescheduleAction = UNNotificationAction(identifier: "rescheduleAction", title: "Reschedule", options: [.authenticationRequired, .foreground])
        let deleteAction = UNNotificationAction(identifier: "deleteAction", title: "Delete Freevent", options: [.authenticationRequired, .destructive])
        
        // Define Category
        let reminderCategory = UNNotificationCategory(identifier: "reminder", actions: [rescheduleAction, deleteAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [])
        
        // Register the category
        center.setNotificationCategories([reminderCategory])
        
        return true
    }
    // handle notifications while user is still in the app
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Override the default behavior of not displaying a banner/alert notification in the foreground
        completionHandler(.alert)
    }
    
    // push local notifications when user is not in the app
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Retrieve the userInfo/data
        let userInfo = response.notification.request.content.userInfo
        
        // Handle notification based on action
        switch response.actionIdentifier {
        case "rescheduleAction":
            // Navigate through to the NewFreeventTableViewController in editMode while preserving the natural navigation stack
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc1 = mainStoryboard.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
            let vc2 = mainStoryboard.instantiateViewController(withIdentifier: "FreeventTableViewController") as! FreeventTableViewController
            let vc3 = mainStoryboard.instantiateViewController(withIdentifier: "NewFreeventTableViewController") as! NewFreeventTableViewController
    
            // Get the freevent from userInfo
            let freevent = Categories.getFreevent(withID: userInfo["id"] as! Int)
            
            // set the frevent and category
            vc3.freevent = freevent
            vc3.category = freevent?.freeCategory
            
            // Set the view controllers in the stack
            rootViewController.setViewControllers([vc1, vc2, vc3], animated: false)
            break
        
        case "deleteAction":
            // Get the freevent from userInfo
            let freevent = Categories.getFreevent(withID: userInfo["id"] as! Int)
            let category = freevent?.freeCategory
            category?.freevents.remove(at: (category?.freevents.index(of: freevent!)!)!)
            
        default:
            break
        }
        
        completionHandler()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

