//
//  ChooseCategoryTableViewController.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/8/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

protocol ChooseCategoryTVCDelegate {
    func passCategory(pCategory: Category)
}

class ChooseCategoryTableViewController: UITableViewController {
    
    var delegate : ChooseCategoryTVCDelegate?   // The ChooseCategoryTableViewController's delegate
    var selectedCategory: Category?             // The currently selected category

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCategoryCell", for: indexPath)

        // Assign the category names to each cell label
        let categoryName = Categories.categories[indexPath.row].catName
        cell.textLabel!.text = categoryName
        
        // If there was a passed selectedCategory, place the checkmark accessory on the cell
        if selectedCategory != nil {
            if categoryName == selectedCategory!.catName { cell.accessoryType = UITableViewCellAccessoryType.checkmark }
        }
        else {
            if indexPath.row == Categories.categories.count - 1 {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell : UITableViewCell?
        
        // Remove the checkmark accessory for all rows
        for idx in 0...tableView.numberOfRows(inSection: 0) {
            cell = tableView.cellForRow(at: IndexPath(row: idx, section: 0))
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        
        // Add the checkmark accessory to the selected row
        cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        // Pass the category selected using the delegate
        delegate?.passCategory(pCategory: Categories.categories[indexPath.row])
    }

}
