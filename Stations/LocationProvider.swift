//
//  LocationProvider.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 18/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import CoreLocation

class LocationProvider: NSObject, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var pendingHandler: (CLLocationCoordinate2D -> Void)?
    
    override init() {
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
                
            case .AuthorizedAlways:
                locationManager.startUpdatingLocation()
                break;
                
            case .NotDetermined, .AuthorizedWhenInUse:
                locationManager.requestAlwaysAuthorization()
                break;
                
            default:
                break;
            }
        }

    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        if status == CLAuthorizationStatus.AuthorizedAlways {
        
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {

            currentLocation = location
            
            if let handler = pendingHandler {
                
                handler(location.coordinate)
                pendingHandler = nil
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // ignore
    }
    
    func runWhenLocationAvailable(handler:(CLLocationCoordinate2D -> Void)) {
        
        if let location = currentLocation {
            
            handler(location.coordinate)
        }
        else {
            
            pendingHandler = handler
        }
    }

}
