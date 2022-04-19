//
//  JHMapDataManager.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 18/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import CardinalKit
import CoreLocation

struct mapPoint: Hashable{
    var latitude: Double
    var longitude: Double
}

class JHMapDataManager: NSObject{
    static let shared = JHMapDataManager()
    
    func getAllMapPoints(onCompletion: @escaping (Any) ->Void){
        guard let mapPointPath = CKStudyUser.shared.mapPointsCollection else {
            onCompletion(false)
            return
        }
        
        var allPoints = [CLLocationCoordinate2D]()
        CKActivityManager.shared.fetchFilteredData(byDate: Date(), route: mapPointPath, field: "currentdate", onCompletion: {(results) in
            if let results = results as? [String:Any]{
                for (_, item) in results{
                    if let item = item as? [String:Any]{
                        if let latitude = item["latitude"] as? Double,
                           let longitude = item["longitude"] as? Double{
                            allPoints.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        }
                    }
                }
            }
            onCompletion(allPoints)
        })
    }
    
}
