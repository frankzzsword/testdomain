//
//  AddRideTableViewController.swift
//  List
//
//  Created by Maria Todd on 7/17/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//
// Table View Controller for the Add Ride table view
//

import UIKit
import Parse

class AddRideTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, getValue{

    
    @IBOutlet weak var fromCityLabel: UILabel!
    
    @IBOutlet weak var toCityLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var car: UILabel!
    
    
    // number of rows per section
    let numOfRows: [Int] = [2, 3, 1]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.title = "Back"
        
        
        //self.tableView.registerClass(AddRideTableViewCell.self, forCellReuseIdentifier: "AddRideTableViewCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 3
    }

    
    /*
     * Returns number of rows per section
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var rows = 0
        
        if (section < numOfRows.count){
            rows = numOfRows[section]
        }
        
        return rows
    }

    var currentSegue: String = ""
    
    /*
     * Set Delegate when loading the second view
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        currentSegue = segue.identifier!
        
        // get FromCityControllerView
        if(segue.identifier == "toPickFromCityView"){
            // get the secondViewController object
            var secondView = segue.destinationViewController as! FromCityViewController
            secondView.delegate = self
        }
        
        // get ToCityControllerView
        if(segue.identifier == "toToCityView"){
            // get the secondViewController object
            var secondView = segue.destinationViewController as! ToCityViewController
            secondView.delegate = self
        }
        
    }
    
    func getUserInput(input: String){
        if(currentSegue == "toPickFromCityView"){
            fromCityLabel.text = input
        }
        if(currentSegue == "toToCityView"){
            toCityLabel.text = input
        }
    }
    
 
    
    @IBAction func goBack(sender: AnyObject) {
        // return back to previous view
        self.navigationController?.popToRootViewControllerAnimated(true)

        
    }
   
    
    
    
    @IBAction func saveButton(sender: AnyObject) {
        /*
         * Setting Default Values for the Labels for now! Until everything is figured out
         */
        dateLabel.text = "today"
        priceLabel.text = "-1"
        car.text = "any"
        
        // uncomment the following code once all the data is coming from user
        // if all the required fields are set by the user, then the "save" button
        // can be pressed
        /*if (dateLabel.text != "" && dateLabel.text != "" && fromCityLabel.text != "Current City"
            && toCityLabel.text != "Any City" && priceLabel.text != -1){*/
        
        if(toCityLabel.text != "Any City" && fromCityLabel.text != "Current Location"){
            // send data to the database
            var rideInfo = PFObject(className: "Ride")
            rideInfo["from_City"] = fromCityLabel.text
            rideInfo["to_City"] = toCityLabel.text
            rideInfo["passengers"] = 3
            rideInfo["price"] = priceLabel.text
            rideInfo["car"] = car.text
            rideInfo["date"] = dateLabel.text
        
            rideInfo.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    
                } else {
                    // There was a problem, check error.description
                    println(error?.description)
                }
            }
        }
        
        //}
        
        // close keyboard
        self.view.endEditing(true)
        
        
        // once the ride is added, jump back to the main view
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        
        
    }
        
        
    /*
     *  Loads cells one by one
     *
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        rideInfoArray.appendCells()
        
        println("Hi")
        
        // get custom cell with identifier "AddRideTableViewCell"
        let customCell: AddRideTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddRideTableViewCell", forIndexPath: indexPath) as AddRideTableViewCell

        
        customCell.topLabel.text = rideInfoArray.arrayOfCellInfo[indexPath.row].firstLabel
        
        customCell.bottomLabel.text = rideInfoArray.arrayOfCellInfo[indexPath.row].secondLabel
        
        // Configure the cell...
        

        return customCell
    }*/
    
}
