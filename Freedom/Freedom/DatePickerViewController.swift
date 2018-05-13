//
//  DatePickerViewController.swift
//  Freedom
//
//  Created by user137759 on 5/12/18.
//  Copyright © 2018 user137759. All rights reserved.
//

import UIKit

protocol DatePickerVCDelegate {
    func passDate(date : Date)
}

class DatePickerViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate : DatePickerVCDelegate?
    var navTitle : String = ""
    let dateFormatter = DateFormatter()
    let format : String = "E, dd/MM/yy h:mm a"
    var date : Date = Date()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navTitle
        datePicker.date = date
        datePicker.minimumDate = Date()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate!.passDate(date: datePicker.date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
