//
//  MapboxView.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 19/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI
import MapboxMaps

struct MapManagerViewWrapper: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MapManagerView
    
    func makeUIViewController(context: Context) -> MapManagerView {
        return MapManagerView()
    }
    
    func updateUIViewController(_ uiViewController: MapManagerView, context: Context) {
        
    }
}

class MapManagerView: UIViewController {
    internal var mapView: MapView!
    var trackingButton:UIButton?=nil
    let pointsFetcher = AlternovaLocationFetcher.shared
    
    let startTrackingLabel = "Start Tracking My Location"
    let stopTrackingLabel = "Stop Tracking My Location"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        MapboxMap.initialiceMap(mapView: mapView, reload: true)
        mapView.location.options.puckType = .puck2D()
        
        
        let button = UIButton(frame: CGRect(x: 200, y: 45, width: 350, height: 50))
        button.center.x = view.center.x
        
        // TODO: add if location is tracking or not
        
        button.setTitle(stopTrackingLabel, for: .normal)
        button.backgroundColor = .red
        
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(startStopTracking), for: .touchUpInside)
        button.layer.cornerRadius = 10
        
        trackingButton = button
        
        self.view.addSubview(button)
        
        
//
//        let buttonUpdate = UIButton(frame: CGRect(x: 200, y: 150, width: 350, height: 50))
//        buttonUpdate.center.x = view.center.x
//
//        // TODO: add if location is tracking or not
//
//        buttonUpdate.setTitle("update", for: .normal)
//        buttonUpdate.backgroundColor = .blue
//
//        buttonUpdate.setTitleColor(.white, for: .normal)
//        buttonUpdate.addTarget(self, action: #selector(updateLocation), for: .touchUpInside)
//        buttonUpdate.layer.cornerRadius = 10
//        self.view.addSubview(buttonUpdate)
    }
    
    @objc
    func startStopTracking(){
        pointsFetcher.startStopTracking()
        
        if pointsFetcher.tracking{
            self.trackingButton?.setTitle(stopTrackingLabel, for: .normal)
            self.trackingButton?.backgroundColor = .systemRed
        }
        else{
            self.trackingButton?.setTitle(startTrackingLabel, for: .normal)
            self.trackingButton?.backgroundColor = .systemGreen
        }
    }
    
    @objc
    func updateLocation(){
        pointsFetcher.locationFetcher.lastKnownLocation = mapView.location.latestLocation?.coordinate
    }
    
}
