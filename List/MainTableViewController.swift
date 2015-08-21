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
import MapKit
import GoogleMaps


class MainTableViewController: UITableViewController, UITableViewDelegate,UISearchBarDelegate, UITableViewDataSource, CLLocationManagerDelegate, searchDisplayProtocol {
    
    
    
    @IBOutlet weak var searchUIView: UIView!
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    @IBOutlet var myTableView: UITableView!
    
    @IBOutlet weak var originCity: UIButton!
    @IBOutlet weak var destinationCity: UIButton!
    
    @IBOutlet weak var tableViewSearch: UITableView!
   
    var fromPlaceNumber: String = ""
    var toPlaceNumber: String = ""

    var currentSegue: String = ""
    
    var searchActive:Bool = false
    var dataArray = cityList.arrayOfCities
    var filtered:[String] = []
    var placesClient: GMSPlacesClient?
    
    var ridesNearby:[PFObject] = []
    var userLocationShown  = false

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fromPlaceNumber = ""
        toPlaceNumber = ""
        //Initializes Google Maps
        placesClient = GMSPlacesClient()
        
        //Color for searchBar
        originCity.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        originCity.layer.cornerRadius = 5.0
        destinationCity.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
        destinationCity.layer.cornerRadius = 5.0


        
        // shows side menu when hamburger button is pressed and hides it when it is pressed again
        if self.revealViewController() != nil {
            menuBar.target = self.revealViewController()
            menuBar.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
       
        
    }
    
        
    override func viewDidAppear(animated: Bool) {
      
        if PFUser.currentUser() != nil && userLocationShown == false{
            userLocationShown = true
            readLocation()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //check if user is logged in through Parse database and redirect the user to login page if not logged it
        if PFUser.currentUser() != nil {
        }
        else  {
            self.performSegueWithIdentifier("login", sender: self)
        }
        rideArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // Protocol for GoogleMaps place identifer
    
    func getFromCity(input: String) {
        if(currentSegue == "pickFromCity"){
            toPlaceNumber = input
            placeDetails(toPlaceNumber, completionHandler: { (placeDetail: GMSPlace) -> () in
                self.originCity.setTitle(placeDetail.name, forState: .Normal)
                self.queryForTable(placeDetail.coordinate.latitude, longitude: placeDetail.coordinate.longitude)

            })

        }
        if(currentSegue == "pickToCity"){
            toPlaceNumber = input
            placeDetails(toPlaceNumber, completionHandler: { (placeDetail: GMSPlace) -> () in
                self.destinationCity.setTitle(placeDetail.name, forState: .Normal)
            })

        }
        
    }
        // get details for place from placeNumber (Google Maps)

    func placeDetails(placeLookUp: String, completionHandler: (placeDetail: GMSPlace) -> ())  {


        placesClient!.lookUpPlaceID(placeLookUp, callback: { (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                println("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                completionHandler(placeDetail: place)
            } else {
                println("No place details for \(placeLookUp)")
            }
        })
        
    }

    @IBAction func currentLocationSearch(sender: AnyObject) {
       rideArray.removeAll()
        readLocation()
    }
    
    
    func readLocation() {

        // User's location
        let userGeoPoint = PFUser.currentUser()?["location"] as! PFGeoPoint
        // Create a query for places
        var query = PFQuery(className:"Ride")
        // Interested in locations near user.
        query.whereKey("from_Coordinates", nearGeoPoint:userGeoPoint, withinMiles: 500)
        // Limit what could be a lot of points.
        query.limit = 10
        // Final list of objects
        var placesObjects = query.findObjects() as! [PFObject]
        self.ridesNearby = placesObjects
        for objects in ridesNearby {
            var coordinates = objects["from_Coordinates"] as! PFGeoPoint
            var from = objects["from_CityName"] as! String
            var to = objects["to_City"] as! String
            var pass = objects["passengers"] as! Int
            var date = objects["date"] as! String
            var price = objects["price"] as! Int
            var comment = objects["comment"] as! String
            var driver = objects["driver"] as! String
            var id = objects.objectId! as String
            
            var requests = []

            // add ride to helper array to be displayed
            let newRide: Ride = Ride(fromCoordinates: coordinates, fromCity: from, toCity: to, price: price, passengers: pass, date: date, comment: comment, objId: id, driver: driver, requests: requests as! [String], passenger: false)
          
            rideArray.append(newRide)
            
        }
        self.myTableView.reloadData()
        
    }
    
    @IBAction func currentLocation(sender: AnyObject) {
        rideArray.removeAll()
        readLocation()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*
    * Description: This function tells the table how many rows there are in the table
    * Return value: Int - number of rows/entries in the table
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var countMe = rideArray.count
        
        return countMe
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
        cell.fromLabel.text = rideArray[indexPath.row].fromCity
        cell.toLabel.text = rideArray[indexPath.row].toCity
        
        cell.price.text = "$" + String(rideArray[indexPath.row].price)
        cell.time.text = rideArray[indexPath.row].date
        
        return cell
        
    }
    
    
    
   
    
    // Define the query that will provide the data for the table view
    func queryForTable(latitude: Double, longitude: Double ) {
        
        //Convert Lat and Long to PFGeopoint
        var cityLatitude = latitude
        var cityLongitude = longitude
        ridesNearby.removeAll()
        
        var cityCoordinates = PFGeoPoint(latitude: cityLatitude, longitude: cityLongitude)
        
        
        
        // Start the query object
        var query = PFQuery(className: "Ride")
        
        // Add a where clause if there is a search criteria
        query.whereKey("from_Coordinates", nearGeoPoint:cityCoordinates, withinMiles: 500)

        var placesObjects = query.findObjects() as! [PFObject]
        println(placesObjects.count)
        if placesObjects.count != 0     {
            rideArray.removeAll()
            self.ridesNearby = placesObjects
            for objects in ridesNearby {
                var coordinates = objects["from_Coordinates"] as! PFGeoPoint
                var from = objects["from_CityName"] as! String
                println(from)
                var to = objects["to_City"] as! String
                var pass = objects["passengers"] as! Int
                var date = objects["date"] as! String
                var price = objects["price"] as! Int
                var comment = objects["comment"] as! String
                var driver = objects["driver"] as! String
                var id = objects.objectId! as String
                
                var requests = []
                
                // add ride to helper array to be displayed
                let newRide: Ride = Ride(fromCoordinates: coordinates, fromCity: from, toCity: to, price: price, passengers: pass, date: date, comment: comment, objId: id, driver: driver, requests: requests as! [String], passenger: false)
                
                rideArray.append(newRide)
            }
            tableView.reloadData()

        }
        else {
            var alert = UIAlertController(title: "No Rides Found", message: "Please search for another city", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    
    func findCityCoordinates(cityName: String, completionHandler: (coordinate: CLLocationCoordinate2D) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { (placemarks: [AnyObject]!, error: NSError!) -> () in
            if let placemark = placemarks[0] as? CLPlacemark {
                let coordinate = placemark.location.coordinate
                
                completionHandler(coordinate: coordinate)
            }
        }
    }
    
    func setCloseTimer() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "close", userInfo: nil, repeats: false)
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        currentSegue = segue.identifier!

        // get FromCityControllerView
        if(segue.identifier == "pickFromCity"){
            // get the secondViewController object
            var secondView = segue.destinationViewController as! CitySearchViewController
            secondView.delegate = self
        }
        
        if(segue.identifier == "pickToCity"){
            // get the secondViewController object
            var secondView = segue.destinationViewController as! CitySearchViewController
            secondView.delegate = self
        }
        
        if segue.identifier == "toRideView" {
            let DestViewController : RequestRideTableViewController = segue.destinationViewController as! RequestRideTableViewController
            var indexPath = self.tableView.indexPathForSelectedRow() //get index of data for selected row
            
            DestViewController.index = indexPath?.row // get data by index and pass it to second view controller

            
        }

            
}

}
