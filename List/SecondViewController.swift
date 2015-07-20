//
//  SecondViewController.swift
//  List
//
//  Created by Maria Todd on 7/11/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import Parse

/*
class SecondViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var datePickerLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var fromBox: UITextField!
    
    @IBOutlet weak var toBox: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //label.text = labelText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // used for UITextFieldDelegate
    
    /*
     * This function gives the ability to press the "return" button 
     * once the user is done typing, to get rid of the keyboard
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool{
    
        
        textField.resignFirstResponder()
        return true
    
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

        // forces any editing commands to end (typing input) 
        self.view.endEditing(true)
    }
    

    
    /* 
     * When Add button is pressed, all the data gets saved to the array
     * sender: UIButton is the add button that fires the event
     */
   
    @IBAction func addButtonClicked(sender: UIButton) {
        
        // if both of the text fields are not empty, store them in the
        // array (rideArray)
        if(count(fromBox.text) != 0 && count(toBox.text) != 0) {
            
            
            
            
            // send data to the database
            var rideInfo = PFObject(className: "Ride")
            rideInfo["from_City"] = fromBox.text
            rideInfo["to_City"] = toBox.text
            
            // save the object I just created in the database with all the fields
            rideInfo.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    println(error?.description)
                }
            }
            
            
            // add new ride to the array
            //rideDataManager.addRide(fromBox.text, toCity: toBox.text)
            
            // close keyboard 
            self.view.endEditing(true)
            
            // empty out the text boxes 
            fromBox.text = ""
            toBox.text = ""
            
            // once it is added, jump back to the main view 
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
   
    
    /* 
     * Sends the date to the database as a String "21-05-2015 20:30"
     */
    @IBAction func datePicked(sender: AnyObject) {
        
        // format the date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        // change the label to the date picked
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        self.datePickerLabel.text = strDate

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}*/
