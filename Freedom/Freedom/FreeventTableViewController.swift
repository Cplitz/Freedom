//
//  FreeventTableViewController.swift
//  Freedom
//
//  Created by user137759 on 5/4/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import UIKit

class FreeventTableViewController: UITableViewController {

    //MARK: Properties
    var category: Category!
    var rowSelected : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        category?.loadFreevents()
        navigationItem.title = "\((category!.catName)!) Freevents"
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

    
    @IBAction func editFreevemt(_ sender: UIButton) {
        rowSelected = sender.tag
        performSegue(withIdentifier: "editFreeventSegue", sender: self)
    }
    
    @IBAction func presentDeleteAlert(_ sender: UIButton) {
        // Create confirmation alert
        let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to delete this Freevent?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel deletion"), style: .cancel
        ))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Confirm Deletion"), style: .default, handler: { _ in self.deleteFreevent(button: sender)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func deleteFreevent(button: UIButton) {
        if category == Categories.upcoming {
            for cat in Categories.categories {
                for f in cat.freevents {
                    if f == category!.freevents[button.tag] {
                        cat.freevents.remove(at: cat.freevents.index(of: f)!)
                    }
                }
            }
        }
        let indexPath = IndexPath(row: button.tag, section: 0)
        category?.freevents.remove(at: button.tag)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return category?.freevents.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> FreeventTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FreeventTableViewCell", for: indexPath) as? FreeventTableViewCell else {
            fatalError("The dequeued cell is not an instance of FreeventTableViewCell")
        }
        
        let freevent = category?.getFreevent(at: indexPath.row)
        // Configure the cell...
        cell.selectionStyle = .none
        cell.nameLabel.text = freevent!.freeName
        cell.photoImageView.image = freevent!.freeImg
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        let timeToEnd : TimeInterval = freevent!.freeEndDate!.timeIntervalSinceNow
        let timeToReminder : TimeInterval = freevent!.freeReminderDate!.timeIntervalSinceNow
        if timeToReminder < 0 {
            cell.timeLeftLabel.textColor = UIColor.red
        }
        
        cell.timeLeftLabel.text = "\(timeToEnd)s"
        
        return cell
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
        if let vc = segue.destination as? UINavigationController {
            if let newFreeventVC = vc.viewControllers[0] as? NewFreeventTableViewController {
                newFreeventVC.freevent = category!.freevents[rowSelected]
            }
        }
        
    }


}
