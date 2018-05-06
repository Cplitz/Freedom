//
//  NewCategoryViewController.swift
//  Freedom
//
//  Created by user137759 on 5/4/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import UIKit

class NewCategoryViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    
    var category : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as? UIBarButtonItem
        
        let name = nameTextField.text ?? ""
        let nUpcoming : UInt32 = 3
        
        category = Category(name, nUpcoming)
    }
    
    
}
