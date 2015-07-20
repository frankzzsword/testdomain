//
//  ToCityViewController.swift
//  List
//
//  Created by Maria Todd on 7/19/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit

class ToCityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var searchBar: UITextField!
    
    
    var delegate: getValue?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Following two functions are used for UITextFieldDelegate
    
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
    
    
    /* 
     * This function sends the user input back to the previous view
     * Once the button is pressed, the current view closes
     */
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
