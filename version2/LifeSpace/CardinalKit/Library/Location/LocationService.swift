//
//  LocationService.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 8/5/21.

import CoreLocation
import Firebase
import Foundation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {

    static let shared = LocationService()

    let manager = CLLocationManager()

    public var allLocations = [CLLocationCoordinate2D]()
    public var onLocationsUpdated: (([CLLocationCoordinate2D]) -> Void)?

    private var previousLocation: CLLocationCoordinate2D?
    private var previousDate: Date?

    @Published var authorizationStatus: CLAuthorizationStatus = CLLocationManager().authorizationStatus
    @Published var canShowRequestMessage: Bool = true
    
    var lastKnownLocation: CLLocationCoordinate2D? {
        didSet {
            guard let lastKnownLocation = lastKnownLocation else {
                return
            }
            self.appendNewLocationPoint(point: lastKnownLocation)
        }
    }

    override init() {
        super.init()
        manager.delegate = self

        calculateIfCanShowRequestMessage()

        // If the user's tracking preference is not set or set to true, then start tracking
        if UserDefaults.standard.value(forKey: Constants.prefTrackingStatus) == nil ||
            UserDefaults.standard.bool(forKey: Constants.prefTrackingStatus) {
            self.startTracking()
        }
    }
    

    func startTracking() {
        if CLLocationManager.locationServicesEnabled() {
            self.manager.startUpdatingLocation()
            self.manager.startMonitoringSignificantLocationChanges()
            self.manager.allowsBackgroundLocationUpdates = true
            self.manager.pausesLocationUpdatesAutomatically = false
            self.manager.showsBackgroundLocationIndicator = false
            print("[LIFESPACE] Starting tracking...")
        } else {
            print("[LIFESPACE] Cannot start tracking - location services are not enabled.")
        }
    }

    func stopTracking() {
        self.manager.stopUpdatingLocation()
        self.manager.stopMonitoringSignificantLocationChanges()
        print("[LIFESPACE] Stopping tracking...")
    }

    func calculateIfCanShowRequestMessage() {
        let previousState = authorizationStatus
        authorizationStatus = self.manager.authorizationStatus

        let first = UserDefaults.standard.bool(forKey: Constants.JHFirstLocationRequest)

        if authorizationStatus == .authorizedWhenInUse && !first && previousState != authorizationStatus {
            UserDefaults.standard.set(true, forKey: Constants.JHFirstLocationRequest)
        } else {
            UserDefaults.standard.set(false, forKey: Constants.JHFirstLocationRequest)
        }

        if authorizationStatus == .authorizedAlways {
            LaunchModel.sharedinstance.showPermissionView = false
        }

        if self.manager.authorizationStatus == .notDetermined || (self.manager.authorizationStatus == .authorizedWhenInUse && UserDefaults.standard.bool(forKey: Constants.JHFirstLocationRequest)) {
            canShowRequestMessage = true
        } else {
            canShowRequestMessage = false
        }
    }

    func requestAuthorizationLocation() {
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestAlwaysAuthorization()
    }

    /// Get all the points for a particular date from the database
    /// - Parameter date: the date for which to fetch all points
    func fetchPoints(date: Date = Date()) {
        JHMapDataManager.shared.getAllMapPoints(date: date, onCompletion: {(results) in
            if let results = results as? [CLLocationCoordinate2D] {
                self.allLocations = results
                self.onLocationsUpdated?(self.allLocations)
            }
        })
    }

    /// Adds a new point to the map and saves the location to the database,
    /// if it meets the criteria to be added.
    /// - Parameter point: the point to add
    func appendNewLocationPoint(point: CLLocationCoordinate2D) {
        var add = true

        if let previousLocation = previousLocation,
           let previousDate = previousDate {

            // Check if distance between current point and previous point is greater than the minimum
            add = LocationUtils.isAboveMinimumDistance(previousLocation: previousLocation,
                                                       currentLocation: point)

            // Reset all points when day changes
            if Date().startOfDay != previousDate.startOfDay {
                add = true
                fetchPoints()
            }
        }

        if add {
            // update local location data for map
            allLocations.append(point)
            onLocationsUpdated?(allLocations)
            previousLocation = point
            previousDate = Date()

            // write this location to the database
            if let mapPointsCollection = CKStudyUser.shared.mapPointsCollection {
                let db = Firestore.firestore()
                db.collection(mapPointsCollection)
                    .document(UUID().uuidString)
                    .setData([
                        "currentdate": NSDate(),
                        "time": NSDate().timeIntervalSince1970,
                        "latitude": point.latitude,
                        "longitude": point.longitude
                    ]) { err in
                        if let err = err {
                            print("[LIFESPACE] Error writing location to database: \(err)")
                        }
                    }
            }
        }
    }

    func userAuthorizeAlways() -> Bool {
        return self.manager.authorizationStatus == .authorizedAlways
    }

    func userAuthorizeWhenInUse() -> Bool {
        return self.manager.authorizationStatus == .authorizedWhenInUse
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        LocationService.shared.calculateIfCanShowRequestMessage()
    }
}
