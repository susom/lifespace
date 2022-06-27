//
//  AlternovaLocationFetcher.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 18/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import CoreLocation
import Foundation

class AlternovaLocationFetcher: NSObject, ObservableObject {
    static let shared = AlternovaLocationFetcher()
    
    var allLocations = [CLLocationCoordinate2D]()
    
    var locationService: LocationService
    var onLocationsUpdated: (([CLLocationCoordinate2D]) -> Void)? = nil
    
    var tracking:Bool = false
    
    var previousLocation:CLLocationCoordinate2D?
    var previousDate:Date?
    
    @Published var authorizationStatus: CLAuthorizationStatus = CLLocationManager().authorizationStatus
    @Published var canShowRequestMessage: Bool = true
    
    override init(){
        locationService = LocationService()
        super.init()

        if UserDefaults.standard.value(forKey: Constants.prefTrackingStatus) == nil {
            UserDefaults.standard.setValue(true, forKey: Constants.prefTrackingStatus)
        }

        if UserDefaults.standard.bool(forKey: Constants.prefTrackingStatus) {
            locationService.startTracking()
        }

        fetchAllTodaypoints()
        calculeIfCanShowRequestMessage()
    }
    
    func calculeIfCanShowRequestMessage() {
        let manager = locationService.manager
        let previousState = authorizationStatus
        authorizationStatus = manager.authorizationStatus
        
        let first = UserDefaults.standard.bool(forKey: Constants.JHFirstLocationRequest)
        
        if(authorizationStatus == .authorizedWhenInUse && !first && previousState != authorizationStatus) {
            UserDefaults.standard.set(true, forKey: Constants.JHFirstLocationRequest)
        } else {
            UserDefaults.standard.set(false, forKey: Constants.JHFirstLocationRequest)
        }
        
        if authorizationStatus == .authorizedAlways {
            LaunchModel.sharedinstance.showPermissionView = false
        }

        if manager.authorizationStatus == .notDetermined || (manager.authorizationStatus == .authorizedWhenInUse && UserDefaults.standard.bool(forKey: Constants.JHFirstLocationRequest)){
            canShowRequestMessage = true
        } else {
            canShowRequestMessage = false
        }
    }
    
    func requestAuthorizationLocation() {
        locationService.manager.requestWhenInUseAuthorization()
        locationService.manager.requestAlwaysAuthorization()
    }
    
    func fetchAllTodaypoints(){
        JHMapDataManager.shared.getAllMapPoints(date: Date(), onCompletion: {(results) in
            if let results = results as? [CLLocationCoordinate2D]{
                self.allLocations = results
                self.onLocationsUpdated?(self.allLocations)
            }
        })
    }
    
    func appendNewLocationPoint(point:CLLocationCoordinate2D) -> Bool {
        if !self.tracking {
            return false
        }

        var add = true

        if let previousLocation = previousLocation,
           let previousDate = previousDate {
            add = false
            let lastLongitude = previousLocation.longitude
            let lastLatitude = previousLocation.latitude
            var distance = 1000.0
            // Calcule distance
            let d2r = (Double.pi / 180.0)
            let dlong = (lastLongitude-point.longitude) * d2r
            let dlat = (lastLatitude-point.latitude) * d2r
            let a = pow(sin(dlat/2.0), 2) + cos(point.latitude*d2r) * cos(lastLongitude*d2r) * pow(sin(dlong/2.0), 2)
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            distance = 6367 * c

            if distance>0.1 {
                add = true
            }
            
            // Reset all points when day change
            if Date().startOfDay != previousDate.startOfDay {
                add = true
                fetchAllTodaypoints()
            }
        }
        
        if add {
            allLocations.append(point)
            onLocationsUpdated?(allLocations)
            previousLocation = point
            previousDate = Date()
        }

        return add
    }
    
    func startStopTracking() {
        if UserDefaults.standard.value(forKey: Constants.prefTrackingStatus) as? Bool == true {
            locationService.stopTracking()
            UserDefaults.standard.set(false, forKey: Constants.prefTrackingStatus)
            //self.tracking = false
            print("Stopping location tracking...")
        } else {
            locationService.startTracking()
            UserDefaults.standard.set(true, forKey: Constants.prefTrackingStatus)
            //self.tracking = true
            print("Starting location tracking...")
        }
    }

    func userAuthorizeAlways() -> Bool {
        let manager = locationService.manager
        return manager.authorizationStatus == .authorizedAlways
    }
    
    func userAuthorizeWhenInUse() -> Bool {
        let manager = locationService.manager
        return manager.authorizationStatus == .authorizedWhenInUse
    }
}
