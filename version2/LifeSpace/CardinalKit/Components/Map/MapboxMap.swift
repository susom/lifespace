//
//  MapBoxMap.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 18/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MapboxMaps

class MapboxMap {
    public static func initializeMap (mapView: MapView, reload: Bool) {
        mapView.mapboxMap.onNext(.mapLoaded){ _ in
            var locationsPoints = [CLLocationCoordinate2D]()
            locationsPoints = LocationService.shared.allLocations
            do {
                // GeoJsonSource
                var source = GeoJSONSource()
                source.data = .feature(Feature(geometry: .multiPoint(MultiPoint(locationsPoints))))
                try mapView.mapboxMap.style.addSource(source, id: "GEOSOURCE")

                var circlesLayer = CircleLayer(id: "CIRCLELAYER")
                circlesLayer.source =  "GEOSOURCE"
                circlesLayer.circleColor = .constant(StyleColor.init(.red))
                circlesLayer.circleStrokeColor = .constant(StyleColor.init(.black))
                circlesLayer.circleStrokeWidth = .constant(2)
                try mapView.mapboxMap.style.addLayer(circlesLayer, layerPosition: .above("country-label"))

                mapView.mapboxMap.setCamera(
                    to: CameraOptions(
                        center: LocationService.shared.allLocations.last,
                        zoom: 14.0
                    )
                )
                if reload {
                    LocationService.shared.onLocationsUpdated = { locations in
                        do {
                            try mapView.mapboxMap.style.updateGeoJSONSource(withId: "GEOSOURCE", geoJSON: .feature(Feature(geometry: .lineString(LineString(locations)))))
                            mapView.mapboxMap.setCamera(
                                to: CameraOptions(
                                    center: LocationService.shared.allLocations.last,
                                    zoom: 14.0
                                )
                            )
                        } catch let error as NSError {
                            print("[LIFESPACE] Error updating map: \(error.localizedDescription)")
                        }
                    }
                }
            } catch let error as NSError {
                print("[LIFESPACE] Error adding source or layer: \(error.localizedDescription)")
            }
        }
    }
}
