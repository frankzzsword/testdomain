// SWRevealViewController


//
//  MainTableViewController.swift
//  List
//
//  Created by Maria Todd on 7/13/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import Parse 

class MainTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    @IBOutlet var myTableView: UITableView!
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        readDatabase()

        // needed to get custom cell displayed on the table view
        // self.tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        myTableView.reloadData()
        
        
        // shows side menu when hamburger button is pressed and hides it when it is pressed again
        if self.revealViewController() != nil {
            menuBar.target = self.revealViewController()
            menuBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        myTableView.reloadData()
    }
    
    

    /*
    ** Helper Function for reading data from the database
    */
    func readDatabase() {
        
        // read data in from the database
        var query = PFQuery(className:"Ride")
        query.orderByAscending("from_City")
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil && objects?.count != 0 {
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        
                        var from = object["from_City"] as! String
                        var to = object["to_City"] as! String
                        
                        // add ride to the helper array
                        rideDataManager.addRide(from, toCity: to)
                        
                    }
                    self.myTableView.reloadData()
                  
                }
                else {
                    // details about the error
                }
            }
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }


    /*
     * Transition to the next view - segue 
     *
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if it is second view segue, get the second view object
        if(segue.identifier == "secondViewSegue"){
            
            // get the secondViewController object
            let secondView = segue.destinationViewController as AddRideTableViewController

            //secondView.labelText = "Changing"
            
        }
    }*/
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }
   
    
   /*
    * Description: This function tells the table how many rows there are in the table
    * Return value: Int - number of rows/entries in the table
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
   
        var countMe = rideDataManager.rideArray.count
        
        return rideDataManager.rideArray.count
    }

    
   /*
    * This function loads all the entries from the array (rideArray) and thus
    * executes as many times as there are elements (rides) in the array
    * Return Value: UITableViewCell - representing an entry in the table
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // get my custom cell with identifier "cell", with labels (fromCity, toCity etc)
        let cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier("cell",  forIndexPath: indexPath) as! TableViewCell
       
        
        // set the labels to whatever is stored in the array
        cell.fromLabel.text = rideDataManager.rideArray[indexPath.row].fromCity
        cell.toLabel.text = rideDataManager.rideArray[indexPath.row].toCity
        
        return cell
        
    }

}
