//
//  ManageRideTableViewController.swift
//  List
//
//  Created by Maria Todd on 7/19/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import Parse

class ManageRideTableViewController: UITableViewController {

    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

   

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var countMe = rideDataManager.rideArray.count
        
        return rideDataManager.rideArray.count
        
    }

    
    /*
     * This function loads the cells.
     * It loads two types of cells: rides that were posted BY the user, and 
     * and rides where user is a passenger. The cells are colored differently to
     * distinguish
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rideCell", forIndexPath: indexPath) as! ManageRideCell

        // Configure the cell...
        
        cell.fromLabel.text = rideDataManager.rideArray[indexPath.row].fromCity
        cell.toLabel.text = rideDataManager.rideArray[indexPath.row].toCity

        return cell
    }
    
    
    /* 
     * This function is responsible for deleting a cell if a user wants to cancel 
     * his/her ride 
     * The ride is deleted from the database, this action can't be undone
     * If a user cancels their own ride, all the passengers need to be notified.
     * If a user cancels a ride as a passenger, the driver user needs to be notified.
     * When deleting your own ride, a pop-up window will appear asking "Are you sure
     * you want to cancel your ride to ---?"
     */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            // save reference to the cell user wants to delete 
            var rideToDelete: ManageRideCell = tableView.cellForRowAtIndexPath(indexPath) as! ManageRideCell
            // remove a cell from the array
            rideDataManager.rideArray.removeAtIndex(indexPath.row)
            // delete that row from the view as well
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            
            // get specific ride object. for now - deletes an object with matching to/from cities
            
            // !!!!!       NEED TO BE RE-WRITTEN       !!!!!
            var ride = PFQuery(className:"Ride")
            ride.whereKey("from_City", equalTo: rideToDelete.fromLabel.text!)
            ride.whereKey("to_City", equalTo: rideToDelete.toLabel.text!)
            
            ride.getFirstObjectInBackgroundWithBlock {
                (object: PFObject?, error: NSError?) -> Void in
                if error != nil || object == nil {
                    println("The getFirstObject request failed.")
                } else {
                    
                    // The find succeeded.
                    // delete the mathcing object from database
                    object!.deleteInBackground()
                    //println("Successfully retrieved the object.")
                }
            }
            
        }
    }
    
    
    /* 
     * Go back to the main view controller
     */
    @IBAction func previousView(sender: AnyObject) {
        
    }
    


}
