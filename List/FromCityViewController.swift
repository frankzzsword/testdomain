//
//  FromCityViewController.swift
//  List
//
//  Created by Maria Todd on 7/18/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import Parse

class FromCityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: getValue?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // forces any editing commands to end (typing input)
        self.view.endEditing(true)
    }
    
    
    
    /* 
     * Jump back to previous view 
     */
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
    @IBAction func saveCity(sender: AnyObject) {
        
        // if the field is not empty, send it to the database and
        // the previous view, to fromCity UILabel
        if(count(searchBar.text) != 0) {
            
            // close keyboard
            self.view.endEditing(true)
            
            delegate?.getUserInput(searchBar.text)
            
            // empty out the text boxes
            searchBar.text = ""
            
            // once the task is added, jump back to the previous view
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
            // return back to previous view
            self.dismissViewControllerAnimated(true, completion: nil)

        }
    }

}
