//
//  WatchDataFormatter.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 17/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import UIKit

class WatchDataFormatter: NSObject {

    class func formatStationList(list:[Station]) -> [String:AnyObject] {
        
        var names = [String]()
        var distances = [String]()
        
        let sortedList = list.sort { (s1:Station, s2:Station) -> Bool in
            
            return s1.distance < s2.distance
        }
        
        for station in sortedList {
            
            names.append(station.name)
            distances.append(String(Int(station.distance)) + " m")
        }
        
        return ["names":names, "distances":distances]
    }
    
}
