//
//  LocationManager.swift
//  LocationService
//
//  Created by 譚德朗 on 30/4/2021.
//

import CoreLocation // Framework to retrieve location
import Foundation

// Location manager has a delegate that monitors if the location has been updated
class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    // Start the location manager.
    let locationManager = CLLocationManager()
    // Initiate a completion handler to get user's CLLocation
    var completion: ((CLLocation) -> Void)?
    // Function to get the user location and returns a CLLocation
    public func getUserLocation(completion: @escaping((CLLocation) -> Void)){
        self.completion = completion
        // Request user's permission to use iOS Location Service
        //checkLocationAuthorisation()
        locationManager.requestWhenInUseAuthorization()
        
        // Initialise delegate
        locationManager.delegate = self
        
        // Getting a reduced accuracy of the location, only interested in the neighbourhood
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        
        // Once allowed, let the manager start updating location
        locationManager.startUpdatingLocation()
    }
    
    // Delegate function - if the location manager has received new locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grabs the first CLLocation in the list of returned locations
        guard let location = locations.first
        else{
            return
        }
        // Call the completion handler once a location has been found
        completion?(location)
    }
}
