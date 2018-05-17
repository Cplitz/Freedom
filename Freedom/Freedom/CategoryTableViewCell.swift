//
//  CategoryTableViewCell.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/4/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!          // Displays the name of the category
    @IBOutlet weak var photoImageView: UIImageView! // Displays the category's icon
    @IBOutlet weak var upcomingLabel: UILabel!      // Displays the number of upcoming freevents contained in the category
    @IBOutlet weak var deleteButton: UIButton!      // Reference to the delete button in the cell
    @IBOutlet weak var editButton: UIButton!        // Reference to the edit button in the cell

}
