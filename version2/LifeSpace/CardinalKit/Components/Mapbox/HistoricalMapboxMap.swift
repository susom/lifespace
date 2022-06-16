//
//  HistoricalMap.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 6/16/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MapboxMaps

class HistoricalMapboxMap {

    public static func initializeMap(date: Date?, mapView: MapView, reload: Bool){
        mapView.mapboxMap.onNext(.mapLoaded){ _ in
            var locationsPoints = [CLLocationCoordinate2D]()

            JHMapDataManager.shared.getAllMapPoints(date: date, onCompletion: {(results) in
                if let results = results as? [CLLocationCoordinate2D]{
                    locationsPoints = results
                }

                do {
                    // GeoJsonSource
                    var source = GeoJSONSource()
                    source.data = .feature(Feature(geometry: .lineString(LineString(locationsPoints))))
                    try mapView.mapboxMap.style.addSource(source, id: "GEOSOURCE")
                    var circlesLayer = CircleLayer(id: "CIRCLELAYER")
                    circlesLayer.source =  "GEOSOURCE"
                    circlesLayer.circleColor = .constant(StyleColor.init(.red))
                    circlesLayer.circleStrokeColor = .constant(StyleColor.init(.black))
                    circlesLayer.circleStrokeWidth = .constant(2)
                    try mapView.mapboxMap.style.addLayer(circlesLayer, layerPosition: .above("country-label"))
                    mapView.mapboxMap.setCamera(
                        to: CameraOptions(
                            center: locationsPoints.last,
                            zoom: 14.0
                        )
                    )
                } catch {
                    print("error adding source or layer: \(error)")
                }
            })
        }
    }
}
