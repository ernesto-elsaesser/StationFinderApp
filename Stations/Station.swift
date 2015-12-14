//
//  Station.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 17/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import CoreLocation

class Station: NSObject {

    var name: String
    var distance: CLLocationDistance
    
    init(name:String, distance:CLLocationDistance) {
        
        self.name = name
        self.distance = distance
    }
}
