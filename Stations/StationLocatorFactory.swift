//
//  StationLocatorFactory.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 17/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import UIKit

class StationLocatorFactory: NSObject {

    class func createInstance() -> StationLocator {
        
        return GoogleMapsLocator()
    }
}
