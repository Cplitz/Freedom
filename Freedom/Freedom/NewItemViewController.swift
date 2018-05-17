//
//  NewItemViewController.swift
//  
//
//  Created by Cameron Pleissnitzer on 5/6/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the navigation controller
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Azedo-Bold", size: 23)!]
    }
    
    //MARK: - Actions
    
    // When the cancel button is pressed, dismiss the view controller
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
