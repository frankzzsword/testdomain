//
//  AddCommentViewController.swift
//  List
//
//  Created by Maria Todd on 7/20/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var comment: UITextView!
    
    var del: getValue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if(comment.text != "Example: I am looking for a fun company to ride along with me to Los Angeles next weekend. I am going to visit my family in Hollywood, so I can drop you off around that area.                                                          I don't mind pets, however absolutely no smoking in the car. ")
        
        comment.textColor = UIColor.lightGrayColor()
        // Do any additional setup after loading the view.
        
        comment.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func textViewShouldBeginEditing(comment: UITextView) -> Bool {
        println("comment.text")
        if (comment.textColor == UIColor.lightGrayColor()) {
            comment.text = ""
            comment.textColor = UIColor.blackColor()
        }
        return true
    }
    */
   /*
    * This function gives the ability to press the "return" button
    * once the user is done typing, to get rid of the keyboard
    */
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // forces any editing commands to end (typing input)
        self.view.endEditing(true)
    }
    
    
    /*
     * This function changes the label with the comment in the
     * previous view, and jumps back to the previous view
     */
    @IBAction func save(sender: AnyObject) {
        
        // if the user changed the comment, display it in the previous screen
        if(comment.text != "Example: I am looking for a fun company to ride along with me to Los Angeles next weekend. I am going to visit my family in Hollywood, so I can drop you off around that area.                                                          I don't mind pets, however absolutely no smoking in the car. " &&
            !comment.text.isEmpty){

            self.view.endEditing(true)
            
            del?.getUserInput(comment.text)
            
            // jump back to the add ride view
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        
      }
        
    
    }
    
    /*
     * When user starts typing, remove the placeholder, and change the color
     * to default black color
     */
    func textViewDidBeginEditing(comment: UITextView) {
        if (comment.textColor == UIColor.lightGrayColor()) {
            comment.text = ""
            comment.textColor = UIColor.blackColor()
        }
    }
    
    
    /* 
     * When the user stops editing the comment, if the comment is empty, 
     * set it back to the placeholder text 
     */
    func textViewDidEndEditing(comment: UITextView) {
        if (comment.text.isEmpty) {
            comment.text = "Example: I am looking for a fun company to ride along with me to Los Angeles next weekend. I am going to visit my family in Hollywood, so I can drop you off around that area.                                                          I don't mind pets, however absolutely no smoking in the car. "
            comment.textColor = UIColor.lightGrayColor()
        }
    }
    
    
    
    
    @IBAction func cancel(sender: AnyObject) {
    
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
