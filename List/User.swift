//
//  User.swift
//  List
//
//  Created by Maria Todd on 7/21/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit

var user: User = User()

class User: NSObject {

    var userRides: [Ride] = []
    
    func addUserRide(ride: Ride){
        userRides.append(ride)
    }
    
}
