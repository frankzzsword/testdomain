//
//  RideDetailsTableViewController.swift
//  List
//
//  Created by Maria Todd on 7/23/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import Parse

class RideDetailsTableViewController: UITableViewController {
    
    var currentRideIndex: Int = 0
    
    var previousView: ManageRideTableViewController?
    
    @IBOutlet weak var myPic: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var fromCity: UILabel!
    
    @IBOutlet weak var toCity: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var departureDate: UILabel!
    
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var postedDate: UILabel!
    
    // if user has pending requests display hidden cells
    var newRequest: Int!
    
    var blur: UIBlurEffect!
    
    var blurView: UIVisualEffectView!
    
    var popupView: UIView!
    
    var declineButton: UIButton!
    
    var dismissButton: UIButton!
    
    var confirmationMessage: UILabel!
    var confirmationMessage2: UILabel!
    
    var cancelButton: UIButton!
    
    @IBOutlet weak var requestLabel: UILabel!
    
    @IBOutlet weak var fromUserRequestLabel: UILabel!
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    @IBOutlet weak var deleteRideButton: UIButton!
    
    @IBOutlet weak var pendingButton: UIButton!
    
    @IBOutlet weak var acceptRequestButton: UIButton!
    
    @IBOutlet weak var declineRequestButton: UIButton!
    
    
    @IBOutlet weak var accepted: UIImageView!
    
    
    @IBOutlet weak var passenger1: UIImageView!
    
    @IBOutlet weak var passenger2: UIImageView!
    
    @IBOutlet weak var passenger3: UIImageView!
    
    
    var currentRideId: String!
    var uniqueRequest: String!
    var passengerId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptPassengerPopUp("Confirmation was sent")
        
        declinePassengerPopUp("Would you like to reject the request?")
        
    }
    
    
    
    
    /*
    * This function sets request cell size to 0 when it's hidden
    * If there are requests, request cell is displayed with details on passenger
    * including their profile picture, message, user name
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        // height of a regular cell
        var height: CGFloat = 123
        
        // if it's 2nd cell (pending request cell) and there are requests
        // display the hidden cell
        if(indexPath.section == 0 && indexPath.row == 1) {
            // if there are requests, display the cells
            if(newRequest > 0) {
                height = 56
                
                // there are requests. Get request, and display info about user who requested
                displayUserInfo()
            }
                
            else{
                height = 0.0
                self.requestLabel.hidden = true
                self.fromUserRequestLabel.hidden = true
                self.userProfilePicture.hidden = true
                self.acceptRequestButton.hidden = true
                self.declineRequestButton.hidden = true
                
            }
            
        }
        
        return height
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.deleteRideButton.hidden = true
        self.deleteRideButton.userInteractionEnabled = false
        self.pendingButton.hidden = true
        self.pendingButton.userInteractionEnabled = false
        
        // get current user name and gender and display them
        name.text = PFUser.currentUser()?["firstName"] as? String
        
        
        self.accepted.hidden = true
        
        // get current ride by rideId
        let objects = getCurrentRide()
        
        for obj in objects {
            
            self.currentRideId = obj.objectId
            
            self.fromCity.text = obj["from_CityName"] as? String
            self.toCity.text = obj["to_City"] as? String
            self.departureDate.text = obj["date"] as? String
            self.price.text = "$" + String(obj["price"] as! Int)
            self.comment.text = obj["comment"] as? String
            

            
            
            
            
            // convert NSDate to string to display as 09:20:2015
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"
            self.postedDate.text = dateFormatter.stringFromDate(obj.createdAt!)
            
            
            // if there are passengers display their pictures
            if(obj["requests"] !== nil){
                if(obj["requests"]!.count > 0){
                    var requestsArray: [String] = obj["requests"] as! [String]
                    for var ind = 1; ind < requestsArray.count; ind += 2 {
                        
                        if(requestsArray[ind] == "accepted") {
                            
                            let userPassengerId = requestsArray[ind - 1]
                            
                            let userQuery = PFUser.query()!
                            
                            userQuery.whereKey("objectId", equalTo: userPassengerId)
                            
                            userQuery.findObjectsInBackgroundWithBlock {
                                (passengerUser: [AnyObject]?, error: NSError?) -> Void in
                                if error == nil {
                                    (passengerUser![0]["profilePicture"] as? PFFile)!.getDataInBackgroundWithBlock {
                                        (imageData: NSData?, error: NSError?) -> Void in
                                        if (error == nil) {
                                            // display profile picture
                                            self.passenger1.image = UIImage(data:imageData!)
                                        }
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
            }
            // if its a ride posted by current user, display delete button
            if(obj["driver"]! as? String == PFUser.currentUser()!.objectId!){
                
                self.deleteRideButton.hidden = false
                self.deleteRideButton.userInteractionEnabled = true
                gender.text = PFUser.currentUser()?["gender"] as? String
                
            }
                
                // if its a ride requested by user, display current state (pending, etc)
            else{
                
                // find unique request object corresponding to this ride and this passenger
                let object = getUniqueRequest()
                for requestObj in object {
                    
                    self.uniqueRequest = requestObj.objectId
                    
                    // if request is pending show pending button
                    if((requestObj["pending"]!) as! Bool == true){
                        
                        self.pendingButton.userInteractionEnabled = true
                        self.pendingButton.hidden = false
                        
                    }
                        // if request was accepted show accepted icon
                    else if((requestObj["requestStatus"]!) as! String == "accepted"){
                        
                        self.accepted.hidden = false
                        self.accepted.image = UIImage(named: "accepted")
                    }
                    
                }
            }
            
        }
        
        
        // display profile picture
        // if current user is driver, display their picture and name
        if(rideArray[currentRideIndex].driver == PFUser.currentUser()?.objectId) {
            if let userPicture = PFUser.currentUser()?["profilePicture"] as? PFFile {
                userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.myPic.image = UIImage(data:imageData!)
                    }
                }
            }
        }
            
            // display picture and name of driver
        else{
            
            let userQuery = PFUser.query()!
            
            userQuery.whereKey("objectId", equalTo: rideArray[currentRideIndex].driver)
            userQuery.findObjectsInBackgroundWithBlock {
                (passengerUser: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    
                    (passengerUser![0]["profilePicture"] as? PFFile)!.getDataInBackgroundWithBlock {
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            self.myPic.image = UIImage(data:imageData!)
                        }
                    }
                    
                    self.name.text = passengerUser![0]["firstName"] as? String
                }
            }
        }
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
        return 6
    }
    
    
    
    
    
    /*
    * This function lets user delete the ride.
    * When user clicks delete ride, a pop-up window shows up
    * asking user to confirm their action. It then deletes the ride
    * from the database as well
    */
    @IBAction func deleteRide(sender: AnyObject) {
        
        // Pop-up message to confirm deleting a ride
        // ask a user to confirm they want to delete the ride
        let alertMessage = UIAlertController(title: "Wait a Minute!", message: "Are you sure you want to delete the ride?",
            preferredStyle: .Alert)
        
        var rideToDelete: Ride = rideArray[currentRideIndex]
        
        // If a user presses yes, deleteRide() helper method is called to delete the ride
        alertMessage.addAction(UIAlertAction(title: "Yes", style: .Default, handler:
            { (alertAction) -> Void in self.deleteRide(self.tableView, rideToDelete: rideToDelete) }))
        
        // If a user presses cancel, the helper function is not called, and the ride stays
        alertMessage.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alertMessage, animated: true, completion: nil)
        
    }
    
    
    
    
    /*
    * This is a helper function to delete a ride. The ride is removed from the local array
    * of rides as well as the database if a user chooses to confirm the deletion
    */
    func deleteRide(tableView: UITableView, rideToDelete: Ride){
        
        
        // get specific ride object, by comparing objectId
        var ride = PFQuery(className: "Ride")
        ride.whereKey("objectId", equalTo: rideArray[currentRideIndex].objectId)
        
        
        // delete the ride from the database
        ride.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                println("The getFirstObject request failed.")
            } else {
                
                // The find succeeded.
                // delete the mathcing object from database
                object!.deleteInBackground()
                
            }
        }
        
        // remove the ride from local array of rides
        rideArray.removeAtIndex(currentRideIndex)
        
        
        // jump back to the previous view
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    /*
    * This function allows user respond to a certain request.
    * By pressing accept, the passenger gets added to the ride.
    * Passenger gets a notification saying that their request was accepted.
    * Pending request becomes 'accepted' in the database
    * A pop-up window shows confirmation
    */
    @IBAction func acceptRequest(sender: AnyObject) {
        
        acceptRideInDataBase()
        
        
        // show confirmation message that passenger was accepted and notified
        showConfirmationPopUp()
        
        
        // hide additional request cell
        hideRequestCell()
        
        
        // show passenger profile picture in passengers
        addedPassenger()
        
    }
    
    
    /*
    * This function allows user to reject a request.
    * When pressing the button a pop-up window will show up asking
    * user to confirm their choice.
    * If a user selects confirm the request will be deleted from
    * the database. It will be deleted from Request class and Ride
    * request array
    */
    @IBAction func declineRide(sender: AnyObject) {
        
        showConfirmation()
        
        
    }
    
    
    
    /*
    * Helper function for declineRide method
    */
    func showConfirmation() {
        
        self.popupView.userInteractionEnabled = true
        self.declineButton.userInteractionEnabled = true
        self.dismissButton.userInteractionEnabled = true
        
        self.blurView.alpha = 0.0
        self.popupView.alpha = 0.0
        self.dismissButton.alpha = 0.0
        self.declineButton.alpha = 0.0
        self.confirmationMessage2.alpha = 0.0
        
        self.view.addSubview(blurView)
        self.view.addSubview(popupView)
        self.view.addSubview(declineButton)
        self.view.addSubview(dismissButton)
        self.view.addSubview(confirmationMessage2)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.popupView.alpha = 1
            self.declineButton.alpha = 1
            self.dismissButton.alpha = 1
            self.confirmationMessage2.alpha = 1
            self.blurView.alpha = 1
            
        })
        
        
    }
    
    
    
    
    
    /*
    * Helper function for acceptRequest method.
    * This function takes care of all the changes in the database.
    * It changes pending field of Request object to false.
    * It also changes status of the request in Ride object to accepted.
    */
    func acceptRideInDataBase(){
        
        
        // change request pending field to false
        let request = PFQuery(className: "Request")
        
        request.getObjectInBackgroundWithId(uniqueRequest) {
            (requestObject: PFObject?, error: NSError?) -> Void in
            if error == nil && requestObject != nil {
                
                requestObject!["pending"]! = false
                requestObject!["requestStatus"] = "accepted"
                requestObject?.saveInBackground()
                
            } else {
                
                println("no object was found")
            }
            
        }
        
        
        // change request array in Ride class
        let ride = PFQuery(className: "Ride")
        
        ride.getObjectInBackgroundWithId(currentRideId) {
            (rideObject: PFObject?, error: NSError?) -> Void in
            if (error == nil && rideObject != nil) {
                
                if var requestArray: [String] = rideObject!["requests"] as? [String] {
                    var indexInArray = 0
                    
                    // find index of passenger id in the array
                    for var ind = 0; ind < requestArray.count; ind += 2 {
                        if(requestArray[ind] == rideArray[self.currentRideIndex].objectId){
                            indexInArray = ind
                            break
                        }
                    }
                    
                    // index of where status is (pending)
                    indexInArray += 1
                    
                    // change array at that index to accepted
                    requestArray[indexInArray] = "accepted"
                    
                    // save in database
                    rideObject!["requests"] = requestArray
                    rideObject?.saveInBackground()
                    
                }
                
            }
            else{
                println("there was an error accessing requests array")
            }
        }
        
        
    }
    
    
    
    
    func declinePassengerPopUp(message: String){
        
        // position pop-up view in the middle of the view
        popupView = UIView(frame: CGRect(x: self.view.center.x - 125,
            y: self.view.center.y - 100, width: 250, height: 180))
        
        popupView.backgroundColor = UIColor.whiteColor()
        popupView.layer.borderColor = UIColor.blackColor().CGColor
        popupView.layer.borderWidth = 0.05
        popupView.layer.cornerRadius = 4
        
        
        confirmationMessage2 = UILabel(frame: CGRect(x: self.view.center.x - 110,
            y: self.view.center.y - 80, width: 220, height: 90))
        // set message
        confirmationMessage2.text = message
        // set color of text to black
        confirmationMessage2.textColor = UIColor.blackColor()
        // change font
        confirmationMessage2.font = UIFont(name: "Heiti TC", size: 15)
        // change color of background
        confirmationMessage2.backgroundColor = UIColor.whiteColor()
        
        
        // dismiss_Button
        
        // position dismiss button within the frame
        dismissButton = UIButton(frame: CGRect(x: self.view.center.x - 110,
            y: self.view.center.y + 25, width: 105, height: 45))
        // set title of the button
        dismissButton.setTitle("Cancel", forState: .Normal)
        // set color of the title on the button to white
        dismissButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        // change font of the button
        dismissButton.titleLabel?.font = UIFont(name: "Heiti TC", size: 15)
        // change color of dismiss button to light green
        dismissButton.backgroundColor = UIColor(red: 155/255.0, green: 151/255.0, blue: 157/255.0, alpha: 1)
        // change border color of the button to black
        dismissButton.layer.borderColor = UIColor.blackColor().CGColor
        // change border width
        dismissButton.layer.borderWidth = 0.05
        // change radius of the corner to be smooth
        dismissButton.layer.cornerRadius = 10
        // if button is pressed, declineRider method is called to reject
        dismissButton.addTarget(self, action: Selector("dismissView"), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Delete request Button
        
        // position dismiss button within the frame
        declineButton = UIButton(frame: CGRect(x: self.view.center.x + 5,
            y: self.view.center.y + 25, width: 105, height: 45))
        // set title of the button
        declineButton.setTitle("Reject", forState: .Normal)
        // set color of the title on the button to black
        declineButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        // change font of the button
        declineButton.titleLabel?.font = UIFont(name: "Heiti TC", size: 15)
        // change color of dismiss button to light green
        declineButton.backgroundColor = UIColor(red: 255/255.0, green: 71/255.0, blue: 102/255.0, alpha: 1)
        // change border color of the button to black
        declineButton.layer.borderColor = UIColor.blackColor().CGColor
        // change border width
        declineButton.layer.borderWidth = 0.05
        // change radius of the corner to be smooth
        declineButton.layer.cornerRadius = 10
        // if button is pressed, declineRider method is called to reject
        declineButton.addTarget(self, action: Selector("rejectRide"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // set blur effect so that it makes the background dark
        blur = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        
    }
    
    /*
    * delete request from database
    */
    func rejectRide(){
        
        
        var requestQuery = PFQuery(className: "Request")
        requestQuery.whereKey("objectId", equalTo: uniqueRequest)
        
        requestQuery.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                println("The getFirstObject request failed.")
            } else {
                
                object!.deleteInBackground()
                
                
            }
        }
        
        var rideQuery = PFQuery(className: "Ride")
        rideQuery.whereKey("objectId", equalTo: currentRideId)
        
        rideQuery.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                println("The getFirstObject request failed.")
            } else {
                
                var requestArray: [String] = (object!["requests"] as? [String])!
                for var ind = 0; ind < requestArray.count; ind += 2 {
                    
                    if(requestArray[ind] == self.passengerId && requestArray[ind+1] == "pending") {
                        requestArray[ind+1] = "rejected"
                        object?["requests"] = requestArray
                        object?.saveInBackground()
                    }
                }
            }
        }
        
        hideRequestCell()
        dismissView()
        
        
    }
    
    
    /*
    * Pop-up window with confirmation message that passenger was added
    */
    func acceptPassengerPopUp(message: String){
        
        // position pop-up view in the middle of the view
        popupView = UIView(frame: CGRect(x: self.view.center.x - 125,
            y: self.view.center.y - 100, width: 250, height: 180))
        
        popupView.backgroundColor = UIColor.whiteColor()
        popupView.layer.borderColor = UIColor.blackColor().CGColor
        popupView.layer.borderWidth = 0.05
        popupView.layer.cornerRadius = 4
        
        
        // display confirmation message
        
        confirmationMessage = UILabel(frame: CGRect(x: self.view.center.x - 110,
            y: self.view.center.y - 80, width: 220, height: 90))
        // set message
        confirmationMessage.text = message
        // set color of text to black
        confirmationMessage.textColor = UIColor.blackColor()
        // change font
        confirmationMessage.font = UIFont(name: "Heiti TC", size: 15)
        // change color of background
        confirmationMessage.backgroundColor = UIColor.whiteColor()
        
        
        // cancel Button
        
        // position dismiss button within the frame
        cancelButton = UIButton(frame: CGRect(x: self.view.center.x - 105,
            y: self.view.center.y + 25, width: 210, height: 45))
        // set title of the button
        cancelButton.setTitle("Okay", forState: .Normal)
        // set color of the title on the button to white
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        // change font of the button
        cancelButton.titleLabel?.font = UIFont(name: "Heiti TC", size: 15)
        // change color of dismiss button to light green
        cancelButton.backgroundColor = UIColor(red: 155/255.0, green: 151/255.0, blue: 157/255.0, alpha: 1)
        // change border color of the button to black
        cancelButton.layer.borderColor = UIColor.blackColor().CGColor
        // change border width
        cancelButton.layer.borderWidth = 0.05
        // change radius of the corner to be smooth
        cancelButton.layer.cornerRadius = 10
        // if button is pressed, declineRider method is called to reject
        cancelButton.addTarget(self, action: Selector("dismissView"),
            forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        // set blur effect so that it makes the background dark
        blur = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        
    }
    
    
    /*
    * This function displays the pop-up confirmation message
    */
    func showConfirmationPopUp(){
        self.popupView.userInteractionEnabled = true
        self.cancelButton.userInteractionEnabled = true
        
        self.blurView.alpha = 0.0
        self.popupView.alpha = 0.0
        self.cancelButton.alpha = 0.0
        self.confirmationMessage.alpha = 0.0
        
        self.view.addSubview(blurView)
        self.view.addSubview(popupView)
        self.view.addSubview(cancelButton)
        self.view.addSubview(confirmationMessage)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.popupView.alpha = 1
            self.cancelButton.alpha = 1
            self.confirmationMessage.alpha = 1
            self.blurView.alpha = 1
            
        })
        
        
    }
    
    
    /*
    * Allows user to press 'okay' to dismiss the pop-up window
    */
    func dismissView(){
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self.blurView.alpha = 0.0
            self.popupView.alpha = 0.0
            self.cancelButton.alpha = 0.0
            self.confirmationMessage.alpha = 0.0
            self.confirmationMessage2.alpha = 0.0
            self.declineButton.alpha = 0.0
            self.dismissButton.alpha = 0.0
            
        })
        
        self.popupView.userInteractionEnabled = false
        self.cancelButton.userInteractionEnabled = false
        self.confirmationMessage.userInteractionEnabled = false
        self.confirmationMessage2.userInteractionEnabled = false
        self.dismissButton.userInteractionEnabled = false
        self.declineButton.userInteractionEnabled = false
        
    }
    
    
    /*
    * Helper function for table cell height function.
    * This function displays info about a passenger who sent request
    * such as their profile picture and name.
    */
    func displayUserInfo(){
        
        var request = PFQuery(className: "Request")
        
        // get all requests for this ride
        request.whereKey("rideId", equalTo: rideArray[currentRideIndex].objectId)
        
        request.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count != 0 {
                if let objects = objects as? [PFObject] {
                    for obj in objects {
                        
                        self.uniqueRequest = obj.objectId
                        
                        self.passengerId = obj["passenger"]! as! String
                        
                        // get user object by their user id
                        var queryPassenger = PFUser.query()!
                        
                        queryPassenger.whereKey("objectId", equalTo: self.passengerId)
                        queryPassenger.findObjectsInBackgroundWithBlock {
                            (passengerUser: [AnyObject]?, error: NSError?) -> Void in
                            if error == nil {
                                
                                
                                // get user name
                                self.fromUserRequestLabel.text = passengerUser![0]["firstName"] as? String
                                
                                // get user profile picture
                                (passengerUser![0]["profilePicture"] as? PFFile)!.getDataInBackgroundWithBlock {
                                    (imageData: NSData?, error: NSError?) -> Void in
                                    if (error == nil) {
                                        // display profile picture
                                        self.userProfilePicture.image = UIImage(data:imageData!)
                                    }
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                }
            }
        }
    }
    
    
    
    
    
    /*
    * Returns array of found PFObjects corresponding to this Ride
    * Thus returns array of one PFObject that corresponds to this ride
    */
    func getCurrentRide() -> [PFObject] {
        
        var currentRide = PFQuery(className: "Ride")
        
        currentRide.whereKey("objectId", equalTo: rideArray[currentRideIndex].objectId)
        
        let currentRideArray = currentRide.findObjects() as? [PFObject]
        
        return currentRideArray!
        
    }
    
    
    
    /*
    * Returns array of found PFObjects corresponding to unique request from certain
    * passenger for current ride
    */
    func getUniqueRequest() -> [PFObject] {
        
        var request = PFQuery(className: "Request")
        
        request.whereKey("rideId", equalTo: currentRideId!)
        request.whereKey("passenger", equalTo: PFUser.currentUser()!.objectId!)
        
        return (request.findObjects() as? [PFObject])!
        
    }
    
    
    /*
    * This function hides request cell when request was accepted
    * or rejected
    */
    func hideRequestCell(){
        
        self.requestLabel.hidden = true
        self.fromUserRequestLabel.hidden = true
        self.userProfilePicture.hidden = true
        self.acceptRequestButton.hidden = true
        self.declineRequestButton.hidden = true
        
        
        self.requestLabel.userInteractionEnabled = false
        self.fromUserRequestLabel.userInteractionEnabled = false
        self.acceptRequestButton.userInteractionEnabled = false
        self.declineRequestButton.userInteractionEnabled = false
        
        
        self.tableView.beginUpdates()
        
        self.tableView.endUpdates()
        
        let myIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        
        let cell = tableView.cellForRowAtIndexPath(myIndexPath)
        
        self.newRequest! -= 1
        cell!.hidden = true
        
        tableView.reloadData()
        
        
        
    }
    
    
    
    func addedPassenger(){
        
        let userQuery = PFUser.query()!
        
        userQuery.whereKey("objectId", equalTo: passengerId)
        userQuery.findObjectsInBackgroundWithBlock {
            (passengerUser: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                (passengerUser![0]["profilePicture"] as? PFFile)!.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        // display profile picture
                        self.passenger1.image = UIImage(data:imageData!)
                        
                    }
                }
            }
        }
    }
    
    
    
}
