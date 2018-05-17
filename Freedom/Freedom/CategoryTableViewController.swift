//
//  CategoryTableViewController.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/4/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    //MARK: Properties
    var rowSelected : Int = 0   // The last selected row
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the navigation bar
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Azedo-Bold", size: 23)!]
        
        // Load saved categories
        if let savedCategories = Categories.loadCategories() {
            Categories.categories += savedCategories
        }
        else {
            Categories.loadSampleCategories()
        }
    }
    
    // Reload the table view data and recalculate upcoming freevents each time the view is reloaded
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        Categories.calculateUpcoming()
    }

    //MARK: - Actions
    
    // Called from the NewFreeventTableViewController and NewCategoryTableViewController Save buttons, handles adding/editing freevents created in those screens
    @IBAction func unwindToCategoryList(sender: UIStoryboardSegue)
    {
        // Add a new category (NOTE: Editing a category just changes its attributes and changes are reflected without additional code here
        if let sourceViewController = sender.source as? NewCategoryTableViewController, let category = sourceViewController.category {
            
            // If the view was not in editing mode, add the newly created category
            if sourceViewController.editMode == false {
                
                // Adds the new category at the correct index - Uncategorized must always be the last in the list
                if let cat = Categories.getCategory(named: "Uncategorized") {
                    Categories.addCategory(cat, at: Categories.categories.index(of: cat)!)
                }
                else {
                    Categories.addCategory(category)
                }
                
                // Get the new index path
                let newIndexPath = IndexPath(row: Categories.categories.index(of: category)!, section: 0)
                
                // Insert the new table view row
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the updated list of categories
            Categories.saveCategories()
        }
        
        // Add a new frevent
        else if let sourceViewController = sender.source as? NewFreeventTableViewController, let freevent = sourceViewController.freevent {
            
            // If the view was not in editing mode, continue to add the freevent
            if sourceViewController.editMode == false {
                
                // Add the freevent to the correct category
                let category = sourceViewController.category
                category?.addFreevent(freevent)
                
                // Update the table view
                if tableView.numberOfRows(inSection: 0) < Categories.categories.count {
                    let newIndexPath = IndexPath(row: Categories.categories.index(of: category!)!, section: 0)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
            
            // Save the updated list of categories (contains updated information of freevents)
            Categories.saveCategories()
            
        }
    }
    
    // Performs a segue to edit a selected category
    @IBAction func editCategory(_ sender: UIButton) {
        rowSelected = sender.tag
        performSegue(withIdentifier: "editCategorySegue", sender: self)
    }
    
    // Deletes a category and asks for confirmation first, indicating all freevents contained will also be deleted
    @IBAction func presentDeleteAlert(_ sender: UIButton) {
        
        // Create confirmation alert
        let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete this category?\nAll contained Freevents will also be deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel deletion"), style: .cancel
        ))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Deletion"), style: .default, handler: { _ in self.deleteCategory(button: sender)
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // Called when the user confirms the delete alert, deletes the category (including all contained freevents)
    func deleteCategory(button: UIButton) {
        
        // Get the index path based on the tag of the delete button
        let indexPath = IndexPath(row: button.tag, section: 0)
        
        // Remove the category from the list of categories and the tableview
        Categories.categories.remove(at: button.tag)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // Save the categories and reload the data
        Categories.saveCategories()
        tableView.reloadData()
        Categories.calculateUpcoming()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell")
        }
        
        // Get the required category
        let category = Categories.getCategory(at: indexPath.row)
        
        // Set the cell attributes specified in CategoryTableViewCell.swift
        cell.selectionStyle = .none
        cell.nameLabel.text = category!.catName
        cell.photoImageView.image = category!.catImg
        
        // Calculate and display the number of upcoming freevents contained in the category
        let nUpcoming : Int = category!.calculateUpcoming()
        if nUpcoming > 0 { cell.upcomingLabel.textColor = UIColor.red }
        else { cell.upcomingLabel.textColor = UIColor.black }
        cell.upcomingLabel.text = "\(nUpcoming)\nUpcoming"
        
        // Convenient method of determining which cell's button was pressed in the table view
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        return cell
    }
    
    // Perform a segue to the FreeventTableViewController with the category contraining the list of freevents
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected = indexPath.row
        performSegue(withIdentifier: "selectCategorySegue", sender: self)
    }

    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue to FreeventTableViewController when a category cell is selected
        if segue.identifier == "selectCategorySegue" {
            let vc = segue.destination as! FreeventTableViewController
            
            // Set the category to display freevents
            vc.category = Categories.getCategory(at: rowSelected)
        }
            
        // Segue to FreeventTableViewController when the Upcoming navigation bar button is selected
        else if segue.identifier == "upcomingCategorySegue" {
            let vc = segue.destination as! FreeventTableViewController
            
            // Set the category to the upcoming category to display upcoming freevents
            vc.category = Categories.upcoming
        }
            
        // Segue to NewCategoryTableViewController when the edit button in a cell is selected
        else if segue.identifier == "editCategorySegue" {
            
            // Must segue to the UINavigation controller first and obtain the NewCategoryTableViewController in the view controller stack to preserve UX
            let navVC = segue.destination as! UINavigationController
            let vc = navVC.viewControllers[0] as! NewCategoryTableViewController
            
            // Set the category to be edited to the category of the selected row
            vc.category = Categories.categories[rowSelected]
        }
    }

}
