//
//  NewFreeventTableTableViewController.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/7/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

class NewFreeventTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChooseCategoryTVCDelegate, DatePickerVCDelegate {
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var freevent : Freevent?            // Holds the freevent to be created or to be edited
    var originalCategory: Category?     // Holds the original passed category before editing
    var category : Category?            // Holds the category chosen for the freevent to be added to
    let minCellHeight = CGFloat(50)     // Minimum height of each cell
    var notesCellHeight = CGFloat()     // Height of the notes cell, needs to be recalculated as text is added to the notesTextView
    var iconCellHeight = CGFloat(275)   // Height of the icon cell
    var rowSelected : Int = 0           // The last selected row
    var editMode : Bool = false         // Whether or not the view was accessed via an edit button or New Freevent... button
    
    let dateFormatter = DateFormatter() // The DateFormatter used to convert dates to strings and vice versa
    let format = "E, dd/MM/yy h:mm a"   // The constant date format used in converting dates and strings
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the categoryLabel
        categoryLabel.text = category!.catName
        
        // Assign delegates
        nameTextField.delegate = self
        notesTextView.delegate = self
        
        // Setup the notesTextView and nameTextField
        nameTextField.layer.borderWidth = 1.0
        notesCellHeight = minCellHeight
        
        // Set the DateFormatters dateFormat to the specified format constant
        dateFormatter.dateFormat = format
        
        // If this view was passed a Freevent from a segue, activate edit mode and load the data from the freevent
        if freevent != nil {
            editMode = true
            originalCategory = category
            loadEditData()
        }
        
        // Update the save button state
        updateSaveButtonState()
    }
    
    //MARK: - Functions
    
    // Loads the data into each field for a passed Freevent
    func loadEditData() {
        // Change the title
        navigationItem.title = "Edit \(freevent!.freeName)"
        
        nameTextField.text = freevent!.freeName
        notesTextView.text = freevent!.freeNotes
        endDateLabel.text = dateFormatter.string(from: freevent!.freeEndDate)
        reminderDateLabel.text = dateFormatter.string(from: freevent!.freeReminderDate)
        photoImageView.image = freevent!.freeImg
        category = freevent!.freeCategory
        categoryLabel.text = category!.catName
    }
    
    // Updates the curent state of the save button (enabled/disabled) based on valid/invalid data
    func updateSaveButtonState() {
        var isValid : Bool = true
        
        // Validate the name text field
        if nameTextField.text == "" {
            nameTextField.layer.borderColor = UIColor.red.cgColor
            
            isValid = false
        }
        else {
            nameTextField.layer.borderColor = UIColor.black.cgColor
        }
        
        // Validate the end date
        if endDateLabel.text == "None" {
            endDateLabel.textColor = UIColor.red
            
            isValid = false
        }
        else {
            endDateLabel.textColor = UIColor.white
        }
        
        // validate the reminder date
        if reminderDateLabel.text == "None" {
            reminderDateLabel.textColor = UIColor.red
            
            isValid = false
        }
        else {
            reminderDateLabel.textColor = UIColor.white
        }
        
        // Set the save button state
        saveButton.isEnabled = isValid
    }
    
    //MARK: - Actions
    
    // When the icon cell is tapped, allow the user to select an image from their photo library
    @IBAction func selectCustomImage(_ sender: Any) {
        // Hide keyboards if user taps the image view while using the keyboard and updates save button state
        nameTextField.resignFirstResponder()
        notesTextView.resignFirstResponder()
        updateSaveButtonState()
        
        // Initialise the image picker controller
        let imagePickerController = UIImagePickerController()
        
        // Assign the source for selecting photos from
        imagePickerController.sourceType = .photoLibrary
        
        // Assign delegate to self
        imagePickerController.delegate = self
        
        // Present the image picker to the user
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - DatePickerVCDelegate
    // Passes the date selected in DatePickerViewController's UIDatePicker to be conveted to a string and displayed to the user
    func passDate(date: Date) {
        
        // Set end date label text
        if rowSelected == 2 {
            endDateLabel.text = dateFormatter.string(from: date)
        }
            
            // Set reminder date label text
        else if rowSelected == 3 {
            reminderDateLabel.text = dateFormatter.string(from: date)
            
            // Set the end date if it occurs before the reminder date
            let diff : TimeInterval = date.timeIntervalSince(dateFormatter.date(from: endDateLabel.text!) ?? Date())
            
            if diff > 0 {
                endDateLabel.text = dateFormatter.string(from: date)
            }
        }
        
        // Update save button state
        updateSaveButtonState()
    }
    
    //MARK: - ChooseCategoryTVCDelegate
    // Passes the category selected in ChooseCategoryTableViewController - using a delegate method was chosen as it is a simple way of reverse navigability through view hierarchies
    func passCategory(pCategory: Category) {
        category = pCategory
        categoryLabel.text = category!.catName
    }
    
    //MARK: - Image Picker Controller Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Remove the ImagePickerView if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    
    // Retrieve the selected image and assign it to the photoImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Try retrieve the image selected from the user's camera roll
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set the photoImageView image (icon TableView row)
        photoImageView.image = selectedImage
        
        // Remove the ImagePickerView when done
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard
        textField.resignFirstResponder()
        
        // Update save button state
        updateSaveButtonState()
        
        return true
    }
    
    // Disable the save button while editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //MARK: - Text View Delegate
    func textViewDidChange(_ textView: UITextView) {
        // Calculate the text view frame size required
        let width = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: width, height: .leastNormalMagnitude))
        
        // Conditional operator to pick the larger of newSize.height and minCellHeight
        notesCellHeight = (newSize.height > minCellHeight ? newSize.height : minCellHeight) + CGFloat(1)
        
        // Set the new frame size
        textView.frame.size = CGSize(width: max(newSize.width, width), height: notesCellHeight)
        
        // Ensures smooth transition of cell height changes
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    // Disable the save button while editing
    func textViewDidBeginEditing(_ textView: UITextView) {
        saveButton.isEnabled = false
    }
    
    // Hides the keyboard when the return key is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        updateSaveButtonState()
        return true
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Notes cell
        if indexPath.row == 1 {
            return notesCellHeight
        }
            
        // Icon cell
        else if indexPath.row == 4 {
            return iconCellHeight
        }
            
        // All other cell
        else {
            return minCellHeight
        }
        
        
    }
    
    // Performs segues to relevant attribute picker screens
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Store the row selected
        rowSelected = indexPath.row
        
        // End date cell
        if indexPath.row == 2 {
            performSegue(withIdentifier: "EndDatePickerSegue", sender: self)
        }
            
        // Reminder date cell
        else if indexPath.row == 3 {
            performSegue(withIdentifier: "ReminderDatePickerSegue", sender: self)
        }
            
        // Add to category cell
        else if indexPath.row == 5 {
            performSegue(withIdentifier: "newFreeventChooseCategorySegue", sender: self)
        }
        
    }


    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Save/Camcel buttons
        if let _ = sender as? UIBarButtonItem {
            
            // Collect field data
            let name = nameTextField.text ?? ""
            let notes = notesTextView.text ?? ""
            let endDate = dateFormatter.date(from: endDateLabel.text!) ?? Date()
            let reminderDate = dateFormatter.date(from: reminderDateLabel.text!) ?? Date()
            let img = photoImageView.image
            
            // If Uncategorized was selected, create new uncategorized category if it does not exist or add to it if it does
            if category == nil {
                
                if let cat = Categories.getCategory(named: "Uncategorized") {
                    category = cat
                }
                else {
                    Categories.categories.append(Category("Uncategorized"))
                    category = Categories.getCategory(named: "Uncategorized")
                }
                
            }
            
            
            // If not in edit mode (creating a new freevent), initialse a new freevent with the relevant data - otherwise remove the freevent from the original category and add it to the new one
            if !editMode {
                freevent = Freevent(name, notes, endDate, reminderDate, category!, img)
            }
            else {
                originalCategory!.freevents.remove(at: originalCategory!.freevents.index(of: freevent!)!)
                category!.addFreevent(freevent!)
                
                // Pass the category back to the FreeventTableViewController (this will not already be set if editMode is accessed from the Reschedule notification action
                let vc = segue.destination as! FreeventTableViewController
                vc.category = category
            }
        }
        
        
        // Attribute picker views
        
        // Choosing a category
        if let vc = segue.destination as? ChooseCategoryTableViewController {
            
            // Assign delegate and assign the currently selected category
            vc.delegate = self
            vc.selectedCategory = category
        }
            
        // Date pickers
        else if let vc = segue.destination as? DatePickerViewController {
            // Choosing an end date
            if segue.identifier == "EndDatePickerSegue" {
                // Assign delegate to self and update navigation bar title
                vc.delegate = self
                vc.navTitle = "End date"
                
                // Change the current date of the UIDatePicker to the current endDate
                if endDateLabel.text != "None" {
                    vc.date = dateFormatter.date(from: endDateLabel.text!)!
                    vc.minDate = dateFormatter.date(from: reminderDateLabel.text!) ?? nil
                }
            }
            
            // Choosing a reminder date
            else if segue.identifier == "ReminderDatePickerSegue" {
                // Assign delegate to self and update navigation bar title
                vc.delegate = self
                vc.navTitle = "Reminder date"
                
                // Set the minDate and maxDate
                vc.minDate = Date()
                vc.maxDate = dateFormatter.date(from: endDateLabel.text ?? "") ?? nil
                
                // Change the current date of the UIDatePicker to the current reminderDate
                if reminderDateLabel.text != "None" {
                    vc.date = dateFormatter.date(from: reminderDateLabel.text!)!
                    
                }
                
            }
        }
        
     }

}
