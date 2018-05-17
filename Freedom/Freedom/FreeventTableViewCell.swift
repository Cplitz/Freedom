//
//  FreeventTableViewCell.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/4/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

class FreeventTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!          // Displays the name of the freevent
    @IBOutlet weak var timeLeftLabel: UILabel!      // Displays the time left until the freeven'ts end date
    @IBOutlet weak var photoImageView: UIImageView! // Displays the freevent's icon
    @IBOutlet weak var deleteButton: UIButton!      // The reference to the delete button of each cell
    @IBOutlet weak var editButton: UIButton!        // The reference to the edit button of each cell
}
