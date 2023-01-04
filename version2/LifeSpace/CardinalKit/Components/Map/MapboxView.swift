//
//  MapboxView.swift
//  LifeSpace
//
//  Created for the LifeSpace project.
//  Copyright © 2022 LifeSpace. All rights reserved.
//

import SwiftUI
import MapboxMaps

struct MapManagerViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapManagerView

    func makeUIViewController(context: Context) -> MapManagerView {
        return MapManagerView()
    }

    func updateUIViewController(_ uiViewController: MapManagerView, context: Context) {}
}

class MapManagerView: UIViewController {
    internal var mapView: MapView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        MapboxMap.initializeMap(mapView: mapView, reload: true)
        mapView.location.options.puckType = .puck2D()
    }
}
