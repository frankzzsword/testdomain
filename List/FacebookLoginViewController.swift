//
//  FacebookLoginViewController.swift
//  List
//
//  Created by Maria Todd on 7/18/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import Parse

class FacebookLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    /* 
     * When button is pressed, it redirects you to fb screen and creates a User class 
     * in Parse
     */
    @IBAction func fbButton(sender: UIButton) {
        
        let permissions = []
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions as [AnyObject]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    //println("User signed up and logged in through Facebook!")
                    
                    self.returnUserData()
                    
                    
                } else {
                    //println("User logged in through Facebook!")
                }
            } else {
                //println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    
    /* 
     * This method can be called to get current user information.
     * It can be called by "self.returnUserData()" after user has logged in
     * Returns
     */
    
    var userName : String = ""
    var userEmail : String = ""
    
   func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {   
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                self.userName = result.valueForKey("name") as! String
                println("User Name is: \(self.userName)")
                // send data to the database
                var name = PFObject(className: "User")
                
                name["Name"] = self.userName
                //name["email"] = self.userEmail as String
                
                // save the object I just created in the database with all the fields
                name.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        
                    } else {
                        // There was a problem, check error.description
                        println(error?.description)
                    }
                }

                //self.userEmail = result.valueForKey("email") as NSString
                //println("User Email is: \(userEmail)")
            }
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
