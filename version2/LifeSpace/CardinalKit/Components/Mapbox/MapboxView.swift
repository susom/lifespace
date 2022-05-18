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
        
//        *** MOVED Tracking Button to HomeView ***
//        self.view.addSubview(button)
        
//        let surveyButton = UIButton(frame: CGRect(x: 200, y: 100, width: 350, height: 50))
//        surveyButton.center.x = view.center.x
//        surveyButton.backgroundColor = .red
//        surveyButton.setTitle("Take Daily Survey", for: .normal)
//        surveyButton.addTarget(self, action: #selector(startSurvey), for: .touchUpInside)
//        surveyButton.layer.cornerRadius = 10
//
//        self.view.addSubview(surveyButton)
        
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
    
//    @objc
//    func startSurvey(){
//        // Only show survey if it is later than 7pm in the user's local time zone
//        let hour = Calendar.current.component(.hour, from: Date())
//        if(hour >= 19){
//            let surveyUIView = CKTaskViewController(tasks: DailySurveyTask(showInstructions: false))
//            let hostingController = UIHostingController(rootView: surveyUIView)
//            present(hostingController, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "Survey Not Available", message:"Please come back after 7pm to take your survey!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    
}
