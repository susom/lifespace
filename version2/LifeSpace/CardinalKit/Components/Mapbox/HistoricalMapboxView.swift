//
//  HistoricalMapView.swift
//  LifeSpace
//
//  Created by Vishnu Ravi on 6/16/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

import SwiftUI
import MapboxMaps

struct HistoricalMapViewWrapper: UIViewControllerRepresentable {
    @Binding var date: Date

    typealias UIViewControllerType = HistoricalMapManagerView

    func makeUIViewController(context: Context) -> HistoricalMapManagerView {
        let mapManager = HistoricalMapManagerView()
        return mapManager
    }

    func updateUIViewController(_ uiViewController: HistoricalMapManagerView, context: Context) {
        print(self.date)
        HistoricalMapboxMap.initializeMap(date: self.date, mapView: uiViewController.mapView, reload: true)
    }
}

class HistoricalMapManagerView: UIViewController {
    internal var mapView: MapView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        HistoricalMapboxMap.initializeMap(date: Date(), mapView: mapView, reload: true)
        mapView.location.options.puckType = .puck2D()

    }
}
