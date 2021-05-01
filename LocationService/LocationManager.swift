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
        
        // Getting a reduced accuracy (to 1 km resolution) of the location, only interested in the neighbourhood
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
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
    
    // A method that takes in a location (CLLocation object), and returns an optional string through the completion handler if a geographic feature has been found.
    public func resolveLocationName(with location: CLLocation, completion: @escaping((String?) -> Void)){
    
        // Initilialise a CLGeocoder object
        let geocoder = CLGeocoder()
        
        // Reverse Geocode, return the first entry in the placemarks array because one location can return multiple geographical features as per the Geocode database
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current){
            placemarks, error in
            guard let place = placemarks?.first, error == nil else{
                completion(nil) // if no geographical names have been returned
                return
            }
            
            var name = ""
            
            // Return the district name
            if let district = place.locality{
                name += district
        }
            
            // Return the ISO Country Code
            if let country = place.isoCountryCode{
                name += ", \(country)"
            }
            
            // Completion handler
            completion(name)
        }
    }
    
    public func resolveExactAddress(with location: CLLocation, completion: @escaping((String?) -> Void)){
    
        // Initilialise a CLGeocoder object
        let geocoder = CLGeocoder()
        
        // Reverse Geocode, return the first entry in the placemarks array because one location can return multiple geographical features as per the Geocode database
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current){
            placemarks, error in
            guard let place = placemarks?.first, error == nil else{
                completion(nil) // if no geographical names have been returned
                return
            }
            
            var name = ""
            
            // Return the geographical feature name
            if let exactName = place.name{
                name += exactName
        }
            
            // Return the street name
            if let thoroughfare = place.thoroughfare{
                name += ", \(thoroughfare)"
            }
            
            // Completion handler
            completion(name)
        }
    }
}

