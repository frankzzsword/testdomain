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
import MapKit


class SearchRideViewController: UITableViewController, UITableViewDataSource, MKMapViewDelegate, UITableViewDelegate, UIPickerViewDelegate, getValue {
    
    
    @IBOutlet weak var fromCityLabel: UILabel!
    
    @IBOutlet weak var toCityLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    var currentSegue: String = ""
    
    var showPickerCell: Bool = true
    
    
    var cityLatitude: CLLocationDegrees?
    var cityLongitude: CLLocationDegrees?
    
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    
    
    
    
    // number of rows per section
    let numOfRows: [Int] = [2, 5, 1]
    
    var arrayOfPrices: [String] = ["Free", "$5.00", "$10.00", "$15.00", "$20.00", "$25.00", "$30.00", "$35.00", "$40.00", "$45.00",
        "$50.00", "$55.00", "$60.00", "$65.00", "$70.00", "$75.00",
        "$80.00", "$85.00", "$90.00", "$95.00", "$100.00"]
    
    
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    * When a price cell is selected, hidden cell with price picker shows up
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
    /*
    * This function hides the picker cell when selection is tapped
    */
    @IBAction func priceSelected(sender: AnyObject) {
        
        // index of the price cell
        let indexP = NSIndexPath(forRow: 2, inSection: 1)
        
        let indexPicker = NSIndexPath(forRow: 3, inSection: 1)
        
        tableView(self.tableView, didSelectRowAtIndexPath: indexP!)
        
        tableView(self.tableView, heightForRowAtIndexPath: indexPicker)
        
    }
    
    
    
    
    /*
    * Sets price picker cell height to 0 when its hidden
    */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        // set height of the cell to "regular" height
        var height: CGFloat = 72
        
        // if the price cell is pressed, change the height to 0
        if(indexPath.section == 1 && indexPath.row == 3) {
                   }
        return height
    }
    
    
    
    
    
    
    /*
    * This function returns number of columns in picker
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        
        return 1
        
    }
    
    /*
    * This function returns number of entries in the picker
    */
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        
        return arrayOfPrices.count
        
    }
    
    /*
    * This function populates picker with array values
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return arrayOfPrices[row]
        
    }
    
    
    
    /*
    * This function hides additional cell when price cell is selected
    */
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //pricePicker.hidden = true
        return false
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
    * Set Delegate when loading the second view
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        currentSegue = segue.identifier!
        
        // get FromCityControllerView
        if(segue.identifier == "toPickFromCityView"){
            // get the secondViewController object
            var secondView = segue.destinationViewController as! MapViewController
            secondView.delegate = self
        }
        
        // get ToCityControllerView
        if(segue.identifier == "toToCityView"){
            // get the secondViewController object
            var secondView = segue.destinationViewController as! MapViewController
            secondView.delegate = self
        }
        if(segue.identifier == "toCommentView"){
            var secondView = segue.destinationViewController as! AddCommentViewController
            secondView.del = self
        }
        
        //get CalendarViewController
        if(segue.identifier == "toCalendarView"){
            var secondView = segue.destinationViewController as! CalendarViewController
            secondView.del = self
        }
        
    }
    
    
    /*
    * Handle the left swipe. Go back to the previos view if swiped left
    *
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    
    println("Swipe Left")
    self.navigationController?.popToRootViewControllerAnimated(true)
    
    
    }*/
    
    
    // used for UITextFieldDelegate
    
    /*
    * This function gives the ability to press the "return" button
    * once the user is done typing, to get rid of the keyboard
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // forces any editing commands to end (typing input)
        self.view.endEditing(true)
    }
    
    
    func getUserInput(input: String){
        if(currentSegue == "toPickFromCityView"){
            println("fromCityLabel")
            fromCityLabel.text = input
            findCityCoordinates(fromCityLabel.text!)
        }
        if(currentSegue == "toToCityView"){
            toCityLabel.text = input
        }
        if(currentSegue == "toCalendarView"){
            dateLabel.text = input
        }
    }
    
    
    @IBAction func goBack(sender: AnyObject) {
        // return back to previous view
        performSegueWithIdentifier("mainTableView", sender: self)
    }
    
    
    /*
    * This function creates a new Ride object and sends it to the database
    * Driver field of the ride object will contain current user objectId
    */
    @IBAction func saveButton(sender: AnyObject) {
        
     
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
        
            
    
    func findCityCoordinates(cityName: String!)  {
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.cityLatitude = placemark.location.coordinate.latitude
                self.cityLongitude = placemark.location.coordinate.longitude
            }
            
        })
    }


}
