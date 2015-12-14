//
//  GoogleMapsLocator.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 17/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import CoreLocation

class GoogleMapsLocator: StationLocator {
    
    static let API_KEY = "AIzaSyDcLCvj97xyCfrYMeoLaHGj44Ot__G9Kk4"
    static let SEARCH_RADIUS = "500"
    
    let session = NSURLSession.sharedSession()
    let components = NSURLComponents()
    
    var userLocation: CLLocation?
    var callback: ([Station] -> Void)?
    
    init() {
        
        components.scheme = "https"
        components.host = "maps.googleapis.com"
        components.path = "/maps/api/place/nearbysearch/json"
    }
    
    func fetchStationsAt(coordinate: CLLocationCoordinate2D, replyHandler: ([Station] -> Void)) {
        
        callback = replyHandler
        userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let locationParam = String(format:"%.6f,%.6f", coordinate.latitude, coordinate.longitude)
        
        let apiParameters = [
            "key":GoogleMapsLocator.API_KEY,
            "location":locationParam,
            "radius":GoogleMapsLocator.SEARCH_RADIUS,
            "types":"train_station|transit_station"]
        
        queryStations(apiParameters)
    }

    
    func queryStations(params:[String:String]) {
        
        var queryItems = [NSURLQueryItem]()
        
        for (name,value) in params {
            
            queryItems.append(NSURLQueryItem(name:name, value:value))
        }
        
        components.queryItems = queryItems;
        
        let request = NSURLRequest(URL: components.URL!);
        
        let task = session.dataTaskWithRequest(request) {urlData, response, reponseError in
            
            if let receivedData = urlData {
                
                do {
                    
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(receivedData, options: [])
                    self.createStationList(jsonData as! Dictionary<String,AnyObject>)
                    
                } catch _ {
                    
                    self.callback!([])
                    
                }
                
            }
            else {
                
                self.callback!([])
            }
        }
        
        task.resume()
        
    }

    func createStationList(jsonData:[String:AnyObject]) {
        
        var stationList = [Station]()
        
        if let results = jsonData["results"] as? [[String:AnyObject]] {
            
            var presentNames = Set<String>()
            
            for result in results {
                
                let stationName = result["name"] as! String
                
                if(presentNames.contains(stationName)) {
                    
                    continue
                }
                
                presentNames.insert(stationName)
                
                let geometry = result["geometry"] as! [String:AnyObject]
                let location = geometry["location"] as! [String:AnyObject]
                let latitude = location["lat"] as! Double
                let longitude = location["lng"] as! Double
                
                let stationLocation = CLLocation(latitude: latitude, longitude: longitude)
                let stationDistance = stationLocation.distanceFromLocation(userLocation!)
                
                if (stationDistance <= MapKitLocator.RADIUS) {
                    
                    stationList.append(Station(name: stationName, distance: stationDistance))
                }
            }
            
        }
        
        callback!(stationList)
    }

}
