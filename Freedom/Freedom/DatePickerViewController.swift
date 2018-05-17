//
//  DatePickerViewController.swift
//  Freedom
//
//  Created by Cameron Pleissnitzer on 5/12/18.
//  Copyright © 2018 Cameron Pleissnitzer. All rights reserved.
//

import UIKit

// Delegate protocol to pass the date selected in the UIDatePicker back up the view hierarchy
protocol DatePickerVCDelegate {
    func passDate(date : Date)
}

class DatePickerViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate : DatePickerVCDelegate?        // The DatePickerViewController delegate
    var navTitle : String = ""                  // The navigation bar title
    let dateFormatter = DateFormatter()         // The DateFormatter used to convert dates to strings and vice versa
    let format : String = "E, dd/MM/yy h:mm a"  // The format used by the DateFormatter to convert dates and strings
    var date : Date = Date()                    // The currently selected date
    var minDate : Date?                         // The minimum date that can be selected
    var maxDate : Date?                         // The maximum date that can be selected
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the navigation bar
        navigationItem.title = navTitle
        
        // Setup the UIDatePicker attributes
        datePicker.date = date
        datePicker.minimumDate = minDate ?? Date()
        datePicker.maximumDate = maxDate ?? nil
    }
    
    // Pass the selected date when returning from the screen
    override func viewWillDisappear(_ animated: Bool) {
        delegate!.passDate(date: datePicker.date)
    }

}
