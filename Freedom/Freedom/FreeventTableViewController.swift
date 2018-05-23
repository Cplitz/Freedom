//
//  FreeventTableViewController.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/4/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit
import UserNotifications

class FreeventTableViewController: UITableViewController {

    //MARK: Properties
    var category: Category!     // The category currently being viewed
    var lastRowSelected : Int = 0   // The last selected row in the table view
    var isRowSelected : Bool = false
    var deselectRow : Bool = false
    var notesCellHeight : CGFloat = CGFloat()
    var minCellHeight : CGFloat = CGFloat(50)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the navigation title
        navigationItem.title = "\(category!.catName) Freevents"
        
        // Configure refresh control
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        // Remove the add button if in the upcoming category
        if category.catName == "Upcoming" {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Functions
    @objc func refresh() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //MARK: - Actions
    
    // Called from the NewFreeventTableViewController save button, handles adding/editing freevents created in those screens
    @IBAction func unwindToFreeventListSave(sender: UIStoryboardSegue)
    {
        // Add a new frevent
        if let sourceViewController = sender.source as? NewFreeventTableViewController, let freevent = sourceViewController.freevent {
            
            if !sourceViewController.editMode {
                // Add the freevent to the correct category
                let category = sourceViewController.category
                category?.addFreevent(freevent)
                
                // Save the updated list of categories (contains updated information of freevents)
                Categories.saveCategories()
            }
            else {
                // Edit the category
                let name = sourceViewController.nameTextField.text ?? ""
                let notes = sourceViewController.notesTextView.text ?? ""
                let endDate = sourceViewController.dateFormatter.date(from: sourceViewController.endDateLabel.text!) ?? Date()
                let reminderDate = sourceViewController.dateFormatter.date(from: sourceViewController.reminderDateLabel.text!) ?? Date()
                let img = sourceViewController.photoImageView.image
                freevent.freeName = name
                freevent.freeNotes = notes
                freevent.freeEndDate = endDate
                freevent.freeReminderDate = reminderDate
                freevent.freeImg = img!
                freevent.freeCategory = sourceViewController.category!
                
                
                // Delete the pending or delivered notification if it exists
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: ["freevent\(freevent.freeID)"])
                center.removeDeliveredNotifications(withIdentifiers: ["freevent\(freevent.freeID)"])
                // Reschedule the notification
                freevent.setupNotification()
                // Reconfigure the badge number
                let app = UIApplication.shared
                app.applicationIconBadgeNumber = Categories.calculateUpcoming()
                
            }
            Categories.saveCategories()
        }
        
    }
    // Called from the NewFreeventTableViewController Cancel button
    @IBAction func unwindToFreeventListCancel(sender: UIStoryboardSegue) {
        // do nothing
    }
    
    
    // Allows editing of a freevent
    @IBAction func editFreevemt(_ sender: UIButton) {
        
        // Set the selected row, identified by the tag of the edit button
        lastRowSelected = sender.tag
        
        // Perform the segue to the edit freevent screen
        performSegue(withIdentifier: "editFreeventSegue", sender: self)
    }
    
    // Deletes a freevent and asks for confirmation first
    @IBAction func presentDeleteAlert(_ sender: UIButton) {
        // Create confirmation alert
        let alert = UIAlertController(title: "Delete Freevent", message: "Are you sure you want to delete this Freevent?", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel deletion"), style: .cancel) )
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Deletion"), style: .default, handler: { _ in self.deleteFreevent(button: sender) }) )
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
        
    }
    // Called when the delete alert is confirmed by the user, deletes the freevent
    func deleteFreevent(button: UIButton) {
        
        // Handle the case where the freevent is deleted in the Upcoming section
        if category == Categories.upcoming {
            // Search for the freevent to delete
            for cat in Categories.categories {
                for f in cat.freevents {
                    if f == category!.freevents[button.tag] {
                        // Remove the freevent
                        cat.freevents.remove(at: cat.freevents.index(of: f)!)
                    }
                }
            }
        }
        
        // Delete the pending or delivered notification if it exists
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["freevent\(category!.freevents[button.tag].freeID)"])
        center.removeDeliveredNotifications(withIdentifiers: ["freevent\(category!.freevents[button.tag].freeID)"])
        
        // Delete the selected freevent and remove it from the tableview
        let indexPath = IndexPath(row: button.tag, section: 0)
        if category?.freevents.count == 1 {
            category?.freevents = []
        }
        else {
            category?.freevents.remove(at: button.tag)
        }
        
        // reconfigure the TableView
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
        
        // reconfigure the badge number
        let app = UIApplication.shared
        app.applicationIconBadgeNumber = Categories.calculateUpcoming()
        
        // Save the categories information
        Categories.saveCategories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.freevents.count + (isRowSelected && category.freevents.count > 0 ? 1 : 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // True index of the freevent
        var freeventIndex : Int = 0
        if isRowSelected {
            if indexPath.row <= lastRowSelected { freeventIndex = indexPath.row }
            else                                { freeventIndex = indexPath.row - 1}
        }
        else {
            freeventIndex = indexPath.row
        }
        
        // Get the required freevent
        let freevent = category.getFreevent(at: freeventIndex)
        
        if isRowSelected && indexPath.row == lastRowSelected + 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotesTableViewCell", for: indexPath) as? NotesTableViewCell  else {
                fatalError("The dequeued cell is not of type NotesTableViewCell")
            }
            cell.notesTextView.text = freevent!.freeNotes
            
            // Calculate the text view frame size required
            let width = cell.notesTextView.frame.size.width
            let newSize = cell.notesTextView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            
            // Set the new cell height required
            notesCellHeight = 20 + (newSize.height > minCellHeight ? newSize.height : minCellHeight)
            
            // Set the new frame size
            cell.notesTextView.frame.size = CGSize(width: max(newSize.width, width), height: notesCellHeight)
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FreeventTableViewCell", for: indexPath) as? FreeventTableViewCell else {
                fatalError("The dequeued cell is not of type FreeventTableViewCell")
            }
            
            // Configure the cell attributes (data from FreeventTableViewCell.swift)
            cell.selectionStyle = .none
            cell.nameLabel.text = freevent!.freeName
            cell.photoImageView.image = freevent!.freeImg
            
            // Convert the time left to readable format
            cell.timeLeftLabel.text = freevent!.readableTimeLeft()
            
            // Convenient method of determining which cell's button was pressed in the table view
            cell.editButton.tag = freeventIndex
            cell.deleteButton.tag = freeventIndex
            
            // Determine if the freevent is upcoming or not and change the time left text color accordingly
            let timeToReminder : TimeInterval = freevent!.freeReminderDate.timeIntervalSinceNow
            
            if timeToReminder < 0 {
                cell.timeLeftLabel.textColor = UIColor.red
            }
            else {
                cell.timeLeftLabel.textColor = UIColor.green
            }
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Identify whwn a row should be deselected (i.e. it was the last row selected)
        if isRowSelected && lastRowSelected == indexPath.row {
            deselectRow = true
        }
        else {
            deselectRow = false
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        if deselectRow {
            tableView.deselectRow(at: indexPath, animated: true)
            isRowSelected = false
            tableView.reloadData()
        }
        else {
            // Assign lastRowSelected to prepare for the notes cell view dropdown
            if isRowSelected {
                if indexPath.row <= lastRowSelected { lastRowSelected = indexPath.row }
                else                                { lastRowSelected = indexPath.row - 1 }
            }
            else {
                lastRowSelected = indexPath.row
            }
            
            isRowSelected = true
            
            // Reload the data to display the dropdown
            tableView.reloadData()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isRowSelected && indexPath.row == lastRowSelected + 1 {
            return notesCellHeight
        }
        else {
            return CGFloat(140)
        }
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue for editing a freevent
        if segue.identifier == "editFreeventSegue" {
            if let newFreeventVC = segue.destination as? NewFreeventTableViewController {
                // Set the freevent
                newFreeventVC.freevent = category!.freevents[lastRowSelected]
                newFreeventVC.category = category
            }
        }
        // Segue for creating a freevent
        else if segue.identifier == "newFreeventSegue" {
            if let newFreeventVC = segue.destination as? NewFreeventTableViewController {
                newFreeventVC.category = category
            }
        }
    }


}
