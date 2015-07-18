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

class AddRideTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    
    // number of rows per section
    let numOfRows: [Int] = [2, 3, 1]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(AddRideTableViewCell.self, forCellReuseIdentifier: "AddRideTableViewCell")
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

    
    /*
     *  Loads cells one by one
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        rideInfoArray.appendCells()
        
        
        // get custom cell with identifier "AddRideTableViewCell"
        let customCell: AddRideTableViewCell = tableView.dequeueReusableCellWithIdentifier("AddRideTableViewCell", forIndexPath: indexPath) as AddRideTableViewCell

        
        customCell.topLabel.text = rideInfoArray.arrayOfCellInfo[indexPath.row].firstLabel
        
        customCell.bottomLabel.text = rideInfoArray.arrayOfCellInfo[indexPath.row].secondLabel
        
        // Configure the cell...
        

        return customCell
    }
    
}
