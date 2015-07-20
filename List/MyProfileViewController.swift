//
//  MyProfileViewController.swift
//  List
//
//  Created by Maria Todd on 7/18/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    
    @IBOutlet weak var userName: UILabel!
    
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
