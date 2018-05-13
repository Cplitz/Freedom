//
//  NewFreeventTableTableViewController.swift
//  Freedom
//
//  Created by user137759 on 5/7/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import UIKit

class NewFreeventTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, ChooseCategoryTVCDelegate, DatePickerVCDelegate {
    func passDate(date: Date) {   
        if rowSelected == 2 {
            endDateLabel.text = dateFormatter.string(from: date)
        }
        else if rowSelected == 3 {
            reminderDateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    func passCategory(pCategory: Category) {
        category = pCategory
    }
    
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var reminderDateLabel: UILabel!
    
    
    var freevent : Freevent?
    var category : Category?
    let minCellHeight: CGFloat = 50
    var notesCellHeight = CGFloat()
    var rowSelected : Int = 0
    var editMode : Bool = false
    
    let dateFormatter = DateFormatter()
    let format = "E, dd/MM/yy h:mm a"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Azedo-Bold", size: 23)!]
        notesTextView.delegate = self
        notesCellHeight = minCellHeight
        
        dateFormatter.dateFormat = format
        
        if freevent != nil {
            editMode = true
            loadEditData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoryLabel.text = category?.catName ?? "Uncategorized"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Functions
    func loadEditData() {
        navigationItem.title = "Edit \((freevent!.freeName)!)"
        nameTextField.text = freevent!.freeName
        notesTextView.text = freevent!.freeNotes
        endDateLabel.text = dateFormatter.string(from: freevent!.freeEndDate!)
        reminderDateLabel.text = dateFormatter.string(from: freevent!.freeReminderDate!)
        category = freevent!.freeCategory
        categoryLabel.text = "\((category!.catName)!)"
    }
    
    //MARK: - Actions
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Text View Delegate
    func textViewDidChange(_ textView: UITextView) {
        // Calculate the text view frame size required
        let width = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        
        notesCellHeight = newSize.height > minCellHeight ? newSize.height : minCellHeight
        
        textView.frame.size = CGSize(width: max(newSize.width, width), height: notesCellHeight)
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return notesCellHeight
        }
        else {
            return minCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected = indexPath.row
        if indexPath.row == 2 {
            performSegue(withIdentifier: "EndDatePicker", sender: self)
        }
        else if indexPath.row == 3 {
            performSegue(withIdentifier: "ReminderDatePicker", sender: self)
        }
        else if indexPath.row == 5 {
            performSegue(withIdentifier: "newFreeventChooseCategorySegue", sender: self)
        }
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        
        // Save/Camcel buttons
        if let _ = sender as? UIBarButtonItem {
            let name = nameTextField.text ?? ""
            let notes = notesTextView.text ?? ""
            let endDate = dateFormatter.date(from: endDateLabel.text!)
            let reminderDate = dateFormatter.date(from: reminderDateLabel.text!)
            
            // Create new uncategorized category if it does not exist or add to it if it does
            if category == nil {
                if let cat = Categories.getCategory(named: "Uncategorized") {
                    category = cat
                }
                else {
                    Categories.categories.append(Category("Uncategorized"))
                    category = Categories.getCategory(named: "Uncategorized")
                }
            }
     
            if editMode {
                freevent!.freeName = nameTextField.text
                freevent!.freeNotes = notesTextView.text
                freevent!.freeEndDate = dateFormatter.date(from: endDateLabel.text!)
                freevent!.freeReminderDate = dateFormatter.date(from: reminderDateLabel.text!)
                //freevent!.freeIcon = nil
                freevent!.freeCategory!.freevents.remove(at: freevent!.freeCategory!.freevents.index(of: freevent!)!)
                freevent!.freeCategory = category
                category?.addFreevent(freevent!)
            }
            else {
                freevent = Freevent(name, notes, endDate!, reminderDate!, nil, category)
            }
        }
        
        
        // Attribute picker views
        if let vc = segue.destination as? ChooseCategoryTableViewController {
            vc.delegate = self
            vc.selectedCategory = category
         }
         else if let vc = segue.destination as? DatePickerViewController {
            if segue.identifier == "EndDatePicker" {
                vc.delegate = self
                vc.navigationItem.title = "End Date"
                
                if endDateLabel.text != "None" {
                    vc.date = dateFormatter.date(from: endDateLabel.text!)!
                }
            }
            else if segue.identifier == "ReminderDatePicker" {
                vc.delegate = self
                vc.navigationItem.title = "Reminder Date"
                
                if reminderDateLabel.text != "None" {
                    vc.date = dateFormatter.date(from: reminderDateLabel.text!)!
                }
            }
        }
        
     }

}
