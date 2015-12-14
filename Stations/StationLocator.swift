//
//  StationLocator.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 17/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import CoreLocation

protocol StationLocator {

    func fetchStationsAt(coordinate: CLLocationCoordinate2D, replyHandler: (([Station]) -> Void))
}
