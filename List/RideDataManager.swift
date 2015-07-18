//
//  RideDataManager.swift
//  List
//
//  Created by Maria Todd on 7/11/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import Parse
import UIKit

//instance of ride class below
var rideDataManager: RideDataManager = RideDataManager()



class RideDataManager: NSObject {
    
    struct Ride{
        
        var fromCity: String
        var toCity: String
        
        init(fromCity: String, toCity: String){
            
            self.fromCity = fromCity
            self.toCity = toCity
            
        }
    }
    
    
    // array of Ride structs
    var rideArray: [Ride] = []
    
    func addRide(fromCity: String, toCity: String){
      
        var newRide = Ride(fromCity: fromCity, toCity: toCity)
        
        rideArray.append(newRide)
        
    }
    
}











