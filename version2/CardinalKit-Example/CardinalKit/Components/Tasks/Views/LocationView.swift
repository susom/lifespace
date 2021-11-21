//
//  LocationView.swift
//  CardinalKit_Example
//
//  Created by Annabel Tan on 7/26/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import MapKit
import SwiftUI

struct LocationView: View {
    
    @ObservedObject var locationFetcher = LocationFetcher()
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        VStack {
            
            Divider()
            
            Button("Get my Location"){
                self.locationFetcher.start()
                print("Starting to fetch location")
            }
            
            Divider()
            
            Button("Print Location") {
                if let location = self.locationFetcher.lastKnownLocation {
                    print("Your location is \(location)")
                } else {
                    print("Your location is unknown")
                }
            }
            
            Divider()
            
            Button("Stop updating location"){
                self.locationFetcher.stop()
                print("Location stopped updating")
            }
            
            Divider()
            
            
            if #available(iOS 14.0, *) {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: 400, height: 300)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
