//
//  MyProfileViewController.swift
//  List
//
//  Created by Maria Todd on 7/18/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        // shows side menu when hamburger button is pressed and hides it when it is pressed again
        if self.revealViewController() != nil {
            menuBar.target = self.revealViewController()
            menuBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("Show User Details")
        println(PFUser.currentUser()?["firstName"]  as? String)
        if let userPicture = PFUser.currentUser()?["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data:imageData!)
                }
            }
        }
        
        firstName.text = PFUser.currentUser()?["firstName"]  as? String
        gender.text = PFUser.currentUser()?["gender"]  as? String
        
        
        
        
    }
    
    
    
    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
        self.performSegueWithIdentifier("default", sender: self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
