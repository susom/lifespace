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
    public static func initialiceMap (mapView: MapView, reload: Bool) {
        mapView.mapboxMap.onNext(.mapLoaded){ _ in
            var locationsPoints = [CLLocationCoordinate2D]()
            locationsPoints = AlternovaLocationFetcher.shared.allLocations
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
                        center: AlternovaLocationFetcher.shared.allLocations.last,
                        zoom: 14.0
                    )
                )
                if reload {
                    AlternovaLocationFetcher.shared.onLocationsUpdated = { locations in
                        do {
                            try mapView.mapboxMap.style.updateGeoJSONSource(withId: "GEOSOURCE", geoJSON: .feature(Feature(geometry: .lineString(LineString(locations)))))
                            mapView.mapboxMap.setCamera(
                                to: CameraOptions(
                                    center: AlternovaLocationFetcher.shared.allLocations.last,
                                    zoom: 14.0
                                )
                            )
                        } catch {
                            print("error updating points")
                        }
                    }
                }
            } catch {
              print("error adding source or layer: \(error)")
            }
        }
    }
}
