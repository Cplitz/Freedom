//
//  ChooseCategoryTableViewController.swift
//  Freedom
//
//  Created by user137759 on 5/8/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import UIKit

protocol ChooseCategoryTVCDelegate {
    func passCategory(pCategory: Category)
}

class ChooseCategoryTableViewController: UITableViewController {
    
    var delegate : ChooseCategoryTVCDelegate?
    var selectedCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    //MARK: Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Categories.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCategoryCell", for: indexPath)

        // Configure the cell...
        let categoryName = Categories.categories[indexPath.row].catName
        cell.textLabel!.text = categoryName
        
        if selectedCategory != nil {
            if categoryName == selectedCategory!.catName { cell.accessoryType = UITableViewCellAccessoryType.checkmark }
        }

        /*'
         if indexPath.row == Categories.categories.count {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
         */
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell : UITableViewCell?
        for idx in 0...tableView.numberOfRows(inSection: 0) {
            cell = tableView.cellForRow(at: IndexPath(row: idx, section: 0))
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        delegate?.passCategory(pCategory: Categories.categories[indexPath.row])
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

}
