//
//  MapKitSearchLocator.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 17/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import CoreLocation
import MapKit

class MapKitLocator: StationLocator {

    static let KEYWORD = "Bahnhof"
    static let RADIUS = 500.0 as CLLocationDistance
    
    var userLocation: CLLocation?
    var callback: ([Station] -> Void)?
    
    func fetchStationsAt(coordinate: CLLocationCoordinate2D, replyHandler: ([Station] -> Void)) {
        
        callback = replyHandler
        userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = MapKitLocator.KEYWORD
        request.region = MKCoordinateRegionMakeWithDistance(coordinate, MapKitLocator.RADIUS, MapKitLocator.RADIUS)
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { (response, error) in
            
            if error != nil {
                
                self.callback!([])
            }
            else if let response = response {
                
                self.extractStationsFrom(response)
            }
        }
    }
    
    func extractStationsFrom(response: MKLocalSearchResponse) {

        var stationList = [Station]()
        
        for item in response.mapItems {
            
            let stationName = item.name!
            let stationLocation = item.placemark.location!
            let stationDistance = stationLocation.distanceFromLocation(userLocation!)
            
            if stationDistance <= MapKitLocator.RADIUS {
                
                stationList.append(Station(name: stationName, distance: stationDistance))
            }
        }
        
        self.callback!(stationList)
    }
    
}
