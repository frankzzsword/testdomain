//
//  RideDataManager.swift
//  List
//
//  Created by Maria Todd on 7/11/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

/* 
 * This class is used when data from the database is read.
 * The array get populated with corresponding data, which later displayed 
 * as table view
**/ 


import Parse
import UIKit
import MapKit

//instance of ride class below
//var rideDataManager: Ride = Ride()

var rideArray: [Ride] = []

class Ride: NSObject {
    
    var fromCoordinates: PFGeoPoint
    var fromCity: String
    var toCity: String
    var price: Int = 0
    var passengers: Int = 3                         //CHANGE TO numberOfPassengers
    var car: String = ""
    var date: String = "today"
    var comment: String = ""
    var objectId: String = ""
    var driver: String = ""
    var requests: [String] = []
    var passenger: Bool = true

    
    
    init (fromCoordinates: PFGeoPoint, fromCity: String, toCity: String, price: Int, passengers: Int,
        date: String, comment: String, objId: String,  driver: String, requests: [String], passenger: Bool){
           
            self.fromCoordinates = fromCoordinates
            self.fromCity = fromCity
            self.toCity = toCity
            self.price = price
            self.passengers = passengers            //CHANGE TO numberOfPassengers
            self.date = date
            self.comment = comment
            self.objectId = objId
            self.driver = driver
            
            self.requests = requests
            self.passenger = passenger
            
    }
    
    
    func addRide(fromCoordinates: PFGeoPoint, fromCity: String, toCity: String, price: Int, passengers: Int, date: String, comment: String, objId: String, driver: String, requests: [String], passenger: Bool){
        
        //CHANGE TO passengers to numberOfPassengers
            var ride: Ride = Ride(fromCoordinates: fromCoordinates, fromCity: fromCity, toCity: toCity, price: price, passengers: passengers, date: date, comment: comment, objId: objId, driver: driver, requests: requests, passenger: passenger)
       
            rideArray.append(ride)
    }
    
}















