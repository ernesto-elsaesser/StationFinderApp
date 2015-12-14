//
//  AppDelegate.swift
//  Stations
//
//  Created by Ernesto Elsäßer on 15/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import UIKit
import CoreLocation
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    
    var session: WCSession!
    var locationProvider: LocationProvider!
    var stationLocator: StationLocator!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        if WCSession.isSupported() {
            
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        locationProvider = LocationProvider()
        stationLocator = StationLocatorFactory.createInstance()
        
        return true
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        locationProvider.runWhenLocationAvailable() { (coordinate:CLLocationCoordinate2D) -> Void in
        
            self.stationLocator.fetchStationsAt(coordinate) { (list:[Station]) -> Void in
                
                let formattedList = WatchDataFormatter.formatStationList(list)
                replyHandler(formattedList)
            }
        }
    }

}

