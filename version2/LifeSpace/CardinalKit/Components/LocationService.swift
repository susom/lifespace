//
//  LocationService.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 8/5/21.

import CoreLocation
import Firebase
import Foundation

class LocationService: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    var lastKnownLocation: CLLocationCoordinate2D? {
        didSet {
            
            guard let longitude = lastKnownLocation?.longitude else {
                return
            }
            
            guard let latitude = lastKnownLocation?.latitude else {
                return
            }
            
            if let lastKnownLocation = lastKnownLocation {

                // Append latest location to the map and then save it to the database
                if AlternovaLocationFetcher.shared.appendNewLocationPoint(point: lastKnownLocation) {
                    if let mapPointsCollection = CKStudyUser.shared.mapPointsCollection {
                        let settings = FirestoreSettings()
                        settings.isPersistenceEnabled = false

                        let db = Firestore.firestore()
                        db.settings = settings

                        db.collection(mapPointsCollection)
                            .document(UUID().uuidString)
                            .setData([
                                "currentdate": NSDate(),
                                "time": NSDate().timeIntervalSince1970,
                                "latitude": latitude,
                                "longitude": longitude
                            ]) { err in
                                if let err = err {
                                    print("Error writing location to database: \(err)")
                                }
                            }
                    }
                }
            }
        }
    }

    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startTracking() {
        if CLLocationManager.locationServicesEnabled() {
            self.manager.startUpdatingLocation()
            self.manager.startMonitoringSignificantLocationChanges()
            self.manager.allowsBackgroundLocationUpdates = true
        } else {
            print("Cannot start tracking - location services are not enabled.")
        }
    }

    func stopTracking() {
        self.manager.stopUpdatingLocation()
        self.manager.stopMonitoringSignificantLocationChanges()
        self.manager.allowsBackgroundLocationUpdates = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        AlternovaLocationFetcher.shared.calculateIfCanShowRequestMessage()
    }
}
