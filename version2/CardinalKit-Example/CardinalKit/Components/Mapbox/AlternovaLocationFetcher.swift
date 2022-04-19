//
//  AlternovaLocationFetcher.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 18/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import CoreLocation
import Foundation

class AlternovaLocationFetcher {
    static let shared = AlternovaLocationFetcher()
    
    var allLocations = [CLLocationCoordinate2D]()
    
    var locationFetcher:LocationFetcher
    var onLocationsUpdated: (([CLLocationCoordinate2D])-> Void)? = nil
    
    var tracking:Bool = false
    
    var previousLocation:CLLocationCoordinate2D?
    var previousDate:Date?
    
    init(){
        locationFetcher = LocationFetcher()
        startStopTracking()
        // Get all previous poitnt
        JHMapDataManager.shared.getAllMapPoints(onCompletion: {(results) in
            if let results = results as? [CLLocationCoordinate2D]{
                self.allLocations = results
                self.onLocationsUpdated?(self.allLocations)
            }
        })
    }
    
    func appendNewLocationPoint(point:CLLocationCoordinate2D) -> Bool{
        var add = true
        if let previousLocation = previousLocation,
           let previousDate = previousDate {
            add = false
            let lastLongitude = previousLocation.longitude
            let lastLatitude = previousLocation.latitude
            var distance = 1000.0
            // Calcule distance
            let d2r = (Double.pi / 180.0)
            let dlong = (lastLongitude-point.longitude) * d2r;
            let dlat = (lastLatitude-point.latitude) * d2r;
            let a = pow(sin(dlat/2.0), 2) + cos(point.latitude*d2r) * cos(lastLongitude*d2r) * pow(sin(dlong/2.0), 2);
            let c = 2 * atan2(sqrt(a), sqrt(1-a));
            distance = 6367 * c;

            if distance>0.1 || Date().startOfDay != previousDate.startOfDay{
                add = true
            }
        }
        
        if add {
            allLocations.append(point)
            onLocationsUpdated?(allLocations)
        }
        previousLocation = point
        previousDate = Date()
        return add
    }
    
    func startStopTracking(){
        if(tracking){
            self.tracking = false
            locationFetcher.manager.stopUpdatingLocation()
        }
        else{
            if CLLocationManager.locationServicesEnabled(){
                self.tracking = true
                locationFetcher.manager.startUpdatingLocation()
                locationFetcher.manager.startMonitoringSignificantLocationChanges()
                locationFetcher.manager.allowsBackgroundLocationUpdates = true
            }
        }
    }
}
