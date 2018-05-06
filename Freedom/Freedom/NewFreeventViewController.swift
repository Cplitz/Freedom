//
//  NewFreeventViewController.swift
//  Freedom
//
//  Created by user137759 on 5/4/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import UIKit

class NewFreeventViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    var freevent : Freevent?
    var category : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as? UIBarButtonItem
        
        let name = nameTextField.text ?? ""
        let notes = notesTextView.text ?? ""
        let endDate = Date(timeIntervalSinceNow: TimeInterval(1))
        let reminderDate = Date(timeIntervalSinceNow: TimeInterval(1))
        if category == nil {
            category = Categories.getCategory(at: Categories.categories.count - 1)
        }
        
        freevent = Freevent(name, notes, endDate, reminderDate, nil, category)
        
    }

}
