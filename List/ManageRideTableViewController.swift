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
        
        displayNotification()
        
        
        rideArray.removeAll()
        tableView.reloadData()
        
        if self.revealViewController() != nil {
            menuBar.target = self.revealViewController()
            menuBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        getUserRides()
    }
    
    
    
    
    /*
    * This function shows a notification on the menu bar, if
    * user has requests from one or more users. This function
    * changes the image of the 'hamburger' menu button to the one
    * with red circle that displays how many notification a user has
    */
    func displayNotification(){
        
        // if user has requests show notification
        // get request objects associated with current driver
        let requests = PFQuery(className: "Request")
        requests.whereKey("driver", equalTo: PFUser.currentUser()!.objectId!)
        requests.findObjectsInBackgroundWithBlock {
            (request: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if(!request!.isEmpty){
                    // if there is a pending request to the driver, show notification
                    if ( (request![0]["pending"]!!) as! Bool == true ){
                        
                        self.menuBar.tintColor = UIColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 1)
                        //self.menuBar.setBackgroundImage(UIImage(named: "notification"), forState: .Normal, barMetrics: UIBarMetrics.Default)
                        
                    }
                    else {
                        self.menuBar.tintColor = UIColor(red: 0.9, green: 0.5, blue: 0.1, alpha: 1)
                    }
                }
            }
        }
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // get uiView object of manage ride view to send the data
        // on what currently selected ride is
        if(segue.identifier == "detailRide"){
            
            let newView = segue.destinationViewController as! RideDetailsTableViewController
            
            // current cell that user selected
            let indexPath: Int = tableView.indexPathForSelectedRow()!.row
            var numOfPendingRequests = 0
            for var ind = 1; ind < rideArray[indexPath].requests.count; ind += 2 {
                
                if ((rideArray[indexPath]).requests[ind] == "pending") {
                    numOfPendingRequests += 1
                }
                
            }
            
            newView.newRequest = numOfPendingRequests
            
            newView.currentRideIndex = indexPath
            newView.previousView = ManageRideTableViewController()
        }
        
    }
    
    /*
    * This function searches for rides associated with current user.
    * Thus it searches for rides posted by current user, and rides
    * requested by current user as passenger.
    * It then populates local array with those entries for display
    */
    func getUserRides() {
        
        rideArray.removeAll()
        
        // get current user
        if let currentU: PFUser = PFUser.currentUser() {
            
            // find matching rides posted by this user (driver)
            var ride = PFQuery(className: "Ride")
            
            ride.whereKey("driver", equalTo: currentU.objectId!)
            
            ride.findObjectsInBackgroundWithBlock{
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects?.count != 0 {
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            
                            var coordinates = object["from_Coordinates"] as! PFGeoPoint
                            var from = object["from_CityName"] as! String
                            var to = object["to_City"] as! String
                            var pass = object["passengers"] as! Int
                            var date = object["date"] as! String
                            var price = object["price"] as! Int
                            var comment = object["comment"] as! String
                            var id = object.objectId! as String
        
                            var driver = object["driver"] as! String;
                            
                            var requests = []
                            
                            // ride has requests or passengers
                            if(object["requests"] != nil ){
                                
                                if( object["requests"]!.count > 0) {
                                    
                                    var requests = object["requests"] as! [String]
                                    
                                    // add ride to helper array to be displayed
                                    let newRide: Ride = Ride(fromCoordinates: coordinates, fromCity: from, toCity: to, price: price, passengers: pass, date: date, comment: comment, objId: id, driver: driver, requests: requests as [String], passenger: false)
                                    user.addUserRide(newRide)
                                    
                                }
                                
                            }
                            else{
                                
                                // add ride to helper array to be displayed
                                let newRide: Ride = Ride(fromCoordinates: coordinates, fromCity: from, toCity: to, price: price, passengers: pass, date: date, comment: comment, objId: id, driver: driver, requests: requests as! [String], passenger: false)
                                
                                rideArray.append(newRide)
                            }
                            
                            
                        }
                        self.tableView.reloadData()
                    }
                    
                    
                }
                
            }
            
            // find rides requested by current user, where user is passenger
            var passenger = PFQuery(className: "Request")
            
            passenger.whereKey("passenger", equalTo: currentU.objectId!)
            
            passenger.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects?.count != 0 {
                    if let objects = objects as? [PFObject] {
                        for obj in objects {
                            
                            var findRide = PFQuery(className: "Ride")
                            
                            findRide.whereKey("objectId", equalTo: obj["rideId"] as! String)
                            
                            findRide.findObjectsInBackgroundWithBlock {
                                (newrides: [AnyObject]?, error: NSError?) -> Void in
                                if error == nil && newrides?.count != 0 {
                                    if let newrides = newrides as? [PFObject] {
                                        for newride in newrides {
                                            
                                            var coordinates = newride["from_Coordinates"] as! PFGeoPoint
                                            var from = newride["from_CityName"] as! String
                                            var to = newride["to_City"] as! String
                                            var pass = newride["passengers"] as! Int
                                            var date = newride["date"] as! String
                                            var price = newride["price"] as! Int
                                            var comment = newride["comment"] as! String
                                            var id = newride.objectId! as String
                                            
                                            var driver = newride["driver"] as! String;
                                            
                                            var requests = []
                                            
                                            // add ride to helper array to be displayed
                                            
                                            let newRide: Ride = Ride(fromCoordinates: coordinates, fromCity: from, toCity: to, price: price, passengers: pass, date: date, comment: comment, objId: id, driver: driver, requests: requests as! [String], passenger: false)
                                            
                                            rideArray.append(newRide)
                                            
                                        }
                                        
                                        self.tableView.reloadData()
                                    }
                                }
                                
                                
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        
        var countMe = rideArray.count
        
        return countMe
        
    }
    
    
    /*
    * This function loads the cells.
    * It loads two types of cells: rides that were posted BY the user, and
    * and rides where user is a passenger. The cells are colored differently to
    * distinguish
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rideCell", forIndexPath: indexPath) as! ManageRideCell
        
        cell.fromLabel.text = rideArray[indexPath.row].fromCity
        cell.toLabel.text = rideArray[indexPath.row].toCity
        cell.date.text = rideArray[indexPath.row].date
        cell.price.text = toString(rideArray[indexPath.row].price)
        
        let rideId = rideArray[indexPath.row].objectId
        
        // if user has pending request, display warning image on that cell
        // if ride has users pending as passengers
        if((rideArray[indexPath.row].requests).count > 0)  {
            
            for var ind = 1; ind < (rideArray[indexPath.row].requests).count; ind += 2 {
                
                
                if((rideArray[indexPath.row].requests)[ind] == "pending") {
                    
                    
                    cell.newRequestAlert.image = UIImage(named: "barMetrics: UIBarMetrics.Default")
                    cell.newRequestAlert.hidden = false
                    cell.backgroundColor = UIColor.yellowColor()
                    
                }
                
            }
        }
        
        
        
        // if it's ride posted by user, display it in one color
        
        // if it's ride where user is passenger display it in a different color
        
        // if user is a passenger, color the cell differently
        if(rideArray[indexPath.row].passenger) {
            cell.backgroundColor = UIColor.orangeColor()
        }
        
        
        
        // display user picture - if driver is current user, display their picture
        if (rideArray[indexPath.row].driver == PFUser.currentUser()?.objectId) {
            if let userPicture = PFUser.currentUser()?["profilePicture"] as? PFFile {
                userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        cell.myPic.image = UIImage(data:imageData!)
                    }
                }
            }
        }
            // else display profile picture of driver user
        else{
            
            // get user object
            let userQuery = PFUser.query()!
            
            userQuery.whereKey("objectId", equalTo: rideArray[indexPath.row].driver)
            userQuery.findObjectsInBackgroundWithBlock {
                (passengerUser: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    
                    (passengerUser![0]["profilePicture"] as? PFFile)!.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            // display profile picture
                            cell.myPic.image = UIImage(data:imageData!)
                        }
                    }
                    
                    
                }
            }
            
            
        }
        
        return cell
    }
    
    
    
    
}
