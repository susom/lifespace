//
//  LocationFetcher.swift
//  LocationTest
//
//  Created by Vishnu Ravi on 8/5/21.


import CoreLocation
import Firebase
import Foundation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    let date = NSDate()
    let unixtime = NSTimeIntervalSince1970
    let authCollection = CKStudyUser.shared.authCollection
    
    var lastKnownLocation: CLLocationCoordinate2D? {
        didSet {
                
            guard let longitude = lastKnownLocation?.longitude else {
                return
            }

            guard let latitude = lastKnownLocation?.latitude else {
                return
            }
            
            //print (latitude)
            //print (longitude)
           
        if let lastKnownLocation = lastKnownLocation,
            AlternovaLocationFetcher.shared.appendNewLocationPoint(point: lastKnownLocation){
                if let authCollection = CKStudyUser.shared.authCollection {
                let settings = FirestoreSettings()
                settings.isPersistenceEnabled = false
                
                let db = Firestore.firestore()
                
                db.settings = settings
                    
                db.collection(authCollection + "location-data")
                    .document(UUID().uuidString)
                    .setData([
                                "currentdate": date,
                                "epoch time (seconds)": unixtime,
                                "latitude": latitude,
                                "longitude": longitude
                    ]) { err in
                    
                    if let err = err {
                        print("[CKSendHelper] sendToFirestoreWithUUID() - error writing document: \(err)")
                    } else {
                        print("[CKSendHelper] sendToFirestoreWithUUID() - document successfully written!")
                    }
                }
                }
            }
        }
    }

    override init() {
        super.init()
        manager.delegate = self
        self.manager.startMonitoringSignificantLocationChanges()
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            self.manager.startMonitoringSignificantLocationChanges()
        }
    }

    
    func stop(){
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        AlternovaLocationFetcher.shared.calculeIfCanShowRequestMessage()
    }
}


