//
//  RequestRideTableViewController.swift
//  List
//
//  Created by Maria Todd on 7/27/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import Parse


class RequestRideTableViewController: UITableViewController {
    
    @IBOutlet weak var myPic: UIImageView!
    
    @IBOutlet weak var driver: UILabel!
    
    @IBOutlet weak var fromCity: UILabel!
    
    @IBOutlet weak var toCity: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var timeOfDay: UILabel!
    
    @IBOutlet weak var comment: UITextView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var requestButton: UIButton!
    
    let cuser = PFUser.currentUser()!
    
    var index: Int?
    
    
    override func viewWillAppear(animated: Bool) {
        
        requestButton.hidden = true
        requestButton.userInteractionEnabled = false
        
        // populate view with details on the ride
        var query = PFUser.query()!
        
        // get user object by their userId
        query.whereKey("objectId", equalTo: rideArray[index!].driver)
        query.findObjectsInBackgroundWithBlock {
            (driverUser: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // get user name
                self.driver.text = driverUser![0]["firstName"] as? String
                // get user image
                let driverPic = driverUser![0]["profilePicture"] as? PFFile
                
                driverPic!.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        // display profile picture
                        self.myPic.image = UIImage(data:imageData!)
                    }
                }
                
                // if ride was not posted by current user, show request button
                if(PFUser.currentUser()?.objectId != driverUser![0].objectId) {
                    
                    
                    // if a user has already sent request to current driver, disable request button for them
                    var rideQuery = PFQuery(className: "Ride")
                    // get current ride
                    rideQuery.getObjectInBackgroundWithId(rideArray[self.index!].objectId) {
                        (ride: PFObject?, error: NSError?) -> Void in
                        
                        if error != nil {
                            println(error)
                        } else if let ride = ride {
                            if ride["requests"] !== nil {
                                if let rideA = ride["requests"]! as? [String] {
                                    // check if current user already sent request for this ride
                                    for var ind = 0; ind < rideA.count; ind += 2 {
                                        if (rideA[ind] == (self.cuser.objectId)) {
                                            // if ride is still pending display pending button
                                            if(rideA[ind+1] == "pending") {
                                                self.requestButton.backgroundColor = UIColor.grayColor()
                                                self.requestButton.setTitle("Pending", forState: .Normal)
                                                self.requestButton.hidden = false
                                                self.requestButton.userInteractionEnabled = false
                                                
                                                
                                            }
                                                // if request was accepted display no buttons
                                            else if(rideA[ind+1] == "accepted") {
                                                
                                                self.requestButton.setTitle("Accepted", forState: .Normal)
                                                self.requestButton.backgroundColor = UIColor(red: 160/255, green: 255/255, blue: 205/255, alpha: 1)
                                                self.requestButton.hidden = false
                                                self.requestButton.userInteractionEnabled = false
                                                
                                                
                                            }
                                                // else request was denied. Display request button again
                                            else{
                                                
                                                self.requestButton.hidden = false
                                                self.requestButton.userInteractionEnabled = true
                                            }
                                        }
                                    }
                                }
                            }
                                // if user never sent a request, display request button
                            else {
                                self.requestButton.hidden = false
                                self.requestButton.userInteractionEnabled = true
                            }
                            
                        }
                        
                    }
                    
                    
                }
            }
        }
        
        // display ride info
        fromCity.text = rideArray[index!].fromCity
        toCity.text = rideArray[index!].toCity
        date.text = rideArray[index!].date
        comment.text = rideArray[index!].comment
        price.text = "$" + toString(rideArray[index!].price)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }
    
    
    
    /*
    * This function executes when user presses "request" button.
    * It asks a user whether they want to send request. If user
    * says "yes", a helper function sendRequest is called to
    * send request to the driver for approval
    */
    @IBAction func requestRide(sender: AnyObject) {
        
        // display pop-up message asking to confirm if user wants to request
        // please provide a comment to the driver
        let alertMessage = UIAlertController(title: "Hold On.", message: "Are you sure you want to request the ride?",
            preferredStyle: .Alert)
        
        // if a user presses yes, call sendrequest function
        alertMessage.addAction(UIAlertAction(title: "Yes", style: .Default, handler:
            { (alertAction) -> Void in self.sendRequest(self.tableView) }))
        
        //if a user presses cancel, sendRequest function is not called
        alertMessage.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alertMessage, animated: true, completion: nil)
        
    }
    
    
    /*
    * This function sends the request to database.
    * It stores driver id (driver of the ride) in an array in User class
    * Each user, who sends a request to someone will have an array with driver
    * ID's to figure out if the user is a passenger
    */
    func sendRequest(tableView: UITableView){
        
        // passenger id
        let passengerId = PFUser.currentUser()!.objectId
        
        let userInfo: [String] = [passengerId!, "pending"]
        
        // if this is not the first request, add to the existing ones
        if ( cuser["myRequests"] !== nil ) {
            
            // get array of requests with driver ID's and pedning options
            if var userRequest: [String] = cuser["myRequests"]! as? [String] {
                // send ride ID and it's state
                userRequest.append(rideArray[index!].objectId)
                userRequest.append("pending")
                
                // append request to user class
                cuser["myRequests"] = userRequest
            }
        }
        else {
            
            // append ride ID and its state
            cuser["myRequests"] = [rideArray[index!].objectId, "pending"]
            
        }
        
        cuser.saveInBackground()
        
        // get selected ride object from database
        var query = PFQuery(className: "Ride")
        // update the ride with new request
        query.getObjectInBackgroundWithId(rideArray[index!].objectId) {
            (ride: PFObject?, error: NSError?) -> Void in
            
            if error != nil {
                println(error)
            } else if let ride = ride {
                
                // get the array of requests to update
                //ride.addUniqueObjectsFromArray([passengerId!, "pending"], forKey: "requests")
                ride["requests"] = userInfo
                ride.saveInBackground()
                
                self.disableRequestButton()
                
                // show a pop-up window confirming the request was sent successfully
                let popUp = UIAlertController(title: "Confirmation", message:
                    "Your Request Has Been Sent.", preferredStyle: UIAlertControllerStyle.Alert)
                popUp.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler:
                    { (alertAction) -> Void in self.goBack() }))
                
                self.presentViewController(popUp, animated: true, completion: nil)
                
            }
        }
        
        
        // request object associated with driver and current passenger
        var request = PFObject(className: "Request")
        request["comment"] = "None"
        request["rideId"] = rideArray[index!].objectId
        request["passenger"] = PFUser.currentUser()!.objectId
        request["driver"] = rideArray[index!].driver
        request["pending"] = true
        request["requestStatus"] = "pending"
        request.saveInBackground()
        
        
    }
    
    
    /*
    * This function dismisses current view. Goes back to main view
    */
    func goBack() {
        // jump back to search screen
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    /*
    * This function disables send request button for users who already sent requests
    */
    func disableRequestButton(){
        
        // change text and color of the button to let user know the request was sent
        self.requestButton.setTitle("Pending", forState: .Normal)
        self.requestButton.backgroundColor = UIColor.grayColor()
        
        // disable user interaction
        self.requestButton.userInteractionEnabled = false
        
    }
    
    
    
    
}
