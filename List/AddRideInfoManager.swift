//
//  AddRideInfoManager.swift
//  List
//
//  Created by Maria Todd on 7/17/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//
// This class has an array to populate the 
// AddRide Table View Cells

import UIKit

var rideInfoArray: AddRideInfoManager = AddRideInfoManager()


class AddRideInfoManager: NSObject {


    struct CellInfo{
      
        var firstLabel: String
        var secondLabel: String
        
        init(firstLabel: String, secondLabel: String) {
            
            self.firstLabel = firstLabel
            self.secondLabel = secondLabel
        
        }
    
    }
    
    
    // array of Info structs for cells
    var arrayOfCellInfo: [CellInfo] = []
    
    
    // populate the array with data
    func appendCells(){
        
        // objects for cells
        var cell1 = CellInfo(firstLabel: "From", secondLabel: "Current Location")
        var cell2 = CellInfo(firstLabel: "To", secondLabel: "Any City")
        var cell3 = CellInfo(firstLabel: "Date", secondLabel: "Today")
        var cell4 = CellInfo(firstLabel: "Price", secondLabel: "-$$-")
        var cell5 = CellInfo(firstLabel: "Passengers", secondLabel: "3")
        var cell6 = CellInfo(firstLabel: "Car Make", secondLabel: "-Not Specified-")
        
        arrayOfCellInfo.append(cell1)
        arrayOfCellInfo.append(cell2)
        arrayOfCellInfo.append(cell3)
        arrayOfCellInfo.append(cell4)
        arrayOfCellInfo.append(cell5)
        arrayOfCellInfo.append(cell6)
    }
    
    
    
    
    // Following functions change labels once the changes are done
    // by the user 
    func setFromCity(fromCity: String){
        arrayOfCellInfo[0].secondLabel = fromCity
    }
    
    func setToCity(toCity: String){
        arrayOfCellInfo[1].secondLabel = toCity
    }
    
    func setDate(newDate: String) {
        arrayOfCellInfo[2].secondLabel = newDate
    }
    
    func setPrice(price: String) {
        arrayOfCellInfo[3].secondLabel = price
    }
    
    func setPassengers(numPass: String) {
        arrayOfCellInfo[4].secondLabel = numPass
    }
    
    func setCarMake(car: String) {
        arrayOfCellInfo[5].secondLabel = car
    }
    

}
