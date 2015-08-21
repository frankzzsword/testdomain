//
//  FacbookLoginViewController.swift
//  List
//
//  Created by Varun Mishra on 7/20/15.
//  Copyright (c) 2015 Maria Lomidze. All rights reserved.
//

import UIKit
import CoreLocation

class FacbookLoginViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var point: PFGeoPoint!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }


    }
    
    func locationManager(manager: CLLocationManager!,
        didUpdateLocations locations: [AnyObject]!)
    {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        point = PFGeoPoint(latitude: locValue.latitude, longitude: locValue.longitude)
        locationManager.stopUpdatingLocation()

    }

    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func facebookLogin() {
        //the permissions required from facebook user
        let permissions = ["email", "user_friends", "public_profile"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions as [AnyObject]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    
                    if((FBSDKAccessToken.currentAccessToken()) != nil){
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, gender"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                            if (error == nil){
                                let fbid = result.valueForKey("id") as! String
                                let email = result.valueForKey("email") as! String
                                let firstname = result.valueForKey("first_name") as! String
                                let userGender = result.valueForKey("gender") as! String
                                
                                let facebookPictureLink = "https://graph.facebook.com/\(fbid)/picture?type=large&return_ssl_resources=1"
                                var URLRequest = NSURL(string: facebookPictureLink)
                                var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                                
                                
                                NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                                    if error == nil {
                                        var picture = PFFile(data: data)
                                        PFUser.currentUser()!.setObject(picture, forKey: "profilePicture")
                                        PFUser.currentUser()!.saveInBackground()
                                    }
                                    else {
                                        println("Error: \(error.localizedDescription)")
                                    }
                                })
                                
                                

                                PFUser.currentUser()?.username = email
                                PFUser.currentUser()?["firstName"] = firstname
                                PFUser.currentUser()?["gender"] = userGender
                                PFUser.currentUser()?["location"] = self.point
                                PFUser.currentUser()!.saveInBackground()
                                
                            }
                        })
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    
                    println("User logged in through Facebook!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}