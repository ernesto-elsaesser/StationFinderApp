//
//  InterfaceController.swift
//  Stations WatchKit Extension
//
//  Created by Ernesto Elsäßer on 15/10/15.
//  Copyright © 2015 elsaesser. All rights reserved.
//

import WatchKit
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var stationTable: WKInterfaceTable!
    
    var session: WCSession!
    var isLoading = false

    override func willActivate() {
        
        super.willActivate()
        
        session = WCSession.defaultSession()
        session.delegate = self
        
        session.activateSession()
        
        if session.reachable {
            
            getStationsFromPhone()
        }
        else {
            
            loadStatus("Connecting ...")
        }
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        
        if session.reachable {
            
            getStationsFromPhone()
        }
    }
    
    func getStationsFromPhone() {
        
        if isLoading {
            
            return
        }
        
        isLoading = true
        
        loadStatus("Loading ...")
            
        session.sendMessage([:], replyHandler: {(answer: [String : AnyObject]) -> Void in
                
            dispatch_async(dispatch_get_main_queue()) {
                
                self.loadResults(answer)
                self.isLoading = false
            }
            
        }, errorHandler: {(error ) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.loadStatus("Error")
                self.isLoading = false
            }
            
        })
        
    }
    
    func loadResults(results: [String : AnyObject]) {
        
        if let names = results["names"] as? [String], distances = results["distances"] as? [String] {
                
            if names.count == 0 {
                
                loadStatus("No results.")
            }
            else {
                
                loadStations(names, distances: distances)
            }
        }
        
    }
    
    func loadStatus(text:String) {
        
        stationTable.setNumberOfRows(1, withRowType: "StatusRow")
        
        if let row = stationTable.rowControllerAtIndex(0) as? StatusRow {
            
            row.lblStatus.setText(text)
        }
    }
    
    func loadStations(names:[String], distances:[String]) {
    
        stationTable.setNumberOfRows(names.count, withRowType: "StationRow")
        
        for index in 0...names.count-1 {
            
            if let row = stationTable.rowControllerAtIndex(index) as? StationRow {
                
                row.lblName.setText(names[index])
                row.lblDistance.setText(distances[index])
            }
        }
        
    }
    
    override func didDeactivate() {
        
        super.didDeactivate()
        
    }

}
