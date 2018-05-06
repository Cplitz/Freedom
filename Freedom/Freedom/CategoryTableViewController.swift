//
//  CategoryTableViewController.swift
//  Freedom
//
//  Created by user137759 on 5/4/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    //MARK: Properties
    var category : Category?
    var rowSelected : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Categories.loadCategories()
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Azedo-Bold", size: 23)!]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Actions
    @IBAction func unwindToCategoryList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? NewCategoryViewController, let category = sourceViewController.category {
            let newIndexPath = IndexPath(row: Categories.categories.count, section: 0)
            Categories.categories.append(category)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        else if let sourceViewController = sender.source as? NewFreeventViewController, let freevent = sourceViewController.freevent {
            let newIndexPath = IndexPath(row: 3, section: 0)
            let category = sourceViewController.category
            category?.freevents.append(freevent)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(Categories.categories.count)
        return Categories.categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell")
        }

        let category = Categories.getCategory(at: indexPath.row)
        
        // Configure the cell...
        cell.nameLabel.text = category?.catName
        cell.photoImageView.image = (category?.catImg)!
        cell.upcomingLabel.text = "\((category?.numUpcoming)!)\nUpcoming"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected = indexPath.row
        performSegue(withIdentifier: "selectCategory", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategory" {
            let vc = segue.destination as! FreeventTableViewController
            vc.category = Categories.getCategory(at: rowSelected)
        }
    }

}
