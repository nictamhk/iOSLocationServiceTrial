//
//  ViewController.swift
//  LocationService
//
//  Created by 譚德朗 on 30/4/2021.
//

import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController {
    
    // Creates a simple view of Apple Maps on the screen.
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map) // Enable a subview of the maps initiated above
        
        title = "Neighbourhood Map"
        
        // Retrieve the location using weak self to avoid memory leak
        LocationManager.shared.getUserLocation{[weak self] location in
            DispatchQueue.main.async{
                guard let strongSelf = self else{
                    return
                }
            
                // Passing the strong Self object to show current location
                strongSelf.showCurrLocation(with: location)
            }
        }
    }
    
    // Gives the map a frame which matches the controller's size
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    // Shows the current location with a CLLocation object
    func showCurrLocation (with location: CLLocation){
        // Shows the "blue dot" of where the user is located
        map.showsUserLocation = true
        
        // Shows the default area of the map
        // MKCoordinateRegion center - Set to the user's location
        // span - zooms in to the neighbourhood of the center by 0.1 longitude and latitude
        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }

}

