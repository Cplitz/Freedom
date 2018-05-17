//
//  NewCategoryTableViewController.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/7/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

class NewCategoryTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!  // Displays the name of the category
    @IBOutlet weak var photoImageView: UIImageView! // Displays the category's icon
    @IBOutlet weak var saveButton: UIBarButtonItem! // Reference to the button which saves the category
    
    
    var category : Category?    // Holds the category to be created or edited
    var editMode : Bool = false // Whether or not the view was accessed via an edit button or New Category... button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign delegate to self
        nameTextField.delegate = self
        nameTextField.layer.borderWidth = 1.0
        
        // Setup the navigation bar
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Azedo-Bold", size: 23)!]
        
        // If this view was passed a Category from a segue, activate edit mode and load the data from the category
        if category != nil {
            editMode = true
            loadEditData()
        }
        
        // Update the save button state
        updateSaveButtonState()
    }
    
    //MARK: - Functions
    // Loads the data into relevant fields from a passed category
    func loadEditData() {
        nameTextField.text = category!.catName
        photoImageView.image = category!.catImg
    }
    
    // Updates the curent state of the save button (enabled/disabled) based on valid/invalid data
    func updateSaveButtonState() {
        var isValid : Bool = true
        
        // Validate the name text field
        if nameTextField.text == "" {
            nameTextField.layer.borderColor = UIColor.red.cgColor
            
            isValid = false
        }
        else if Categories.categories.count == 0 {
            nameTextField.layer.borderColor = UIColor.black.cgColor
        }
        else if !editMode {
            // Validate no duplicate category names
            for cat in Categories.categories {
                if cat.catName == nameTextField.text {
                    nameTextField.layer.borderColor = UIColor.red.cgColor
                    
                    isValid = false
                    break
                }
                else {
                    nameTextField.layer.borderColor = UIColor.black.cgColor
                }
            }
        }

        // Set the save button state
        saveButton.isEnabled = isValid
    }
    
    //MARK: - Actions
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // When the icon cell is tapped, allow the user to select an image from their photo library
    @IBAction func selectCustomImage(_ sender: UITapGestureRecognizer) {
        // Hide keyboards if user taps the image view while using the keyboard and update the save button state
        nameTextField.resignFirstResponder()
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
    
    //MARK: - Image Picker Controller Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Retrieve the selected image and assign it to the photoImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        
        // Update the save button state
        updateSaveButtonState()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let name = nameTextField.text ?? ""
        
        // If in edit mode, update the passed category's details
        if editMode {
            category!.catName = nameTextField.text!
            category!.catImg = photoImageView.image
            
        }
        // If not in edit mode, create a new category from the field data
        else {
            category = Category(name, photoImageView.image)
        }
    }


}
