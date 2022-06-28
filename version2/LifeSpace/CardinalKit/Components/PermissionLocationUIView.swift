//
//  PermissionLocationUIView.swift
//  CardinalKit_Example
//
//  Created by Esteban Ramos on 19/04/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import SwiftUI

struct PermissionLocationUIView: View {
    
    let color: Color
    let config = CKPropertyReader(file: "CKConfiguration")
    
    @ObservedObject var locationFetcher = AlternovaLocationFetcher.shared
    
    init(onComplete: (() -> Void)? = nil) {
        
        self.color = Color(config.readColor(query: "Primary Color"))
        
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            Image("LifeSpace")
                .resizable()
                .scaledToFit()
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*4)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*4)
            
            Text("To participate in the study, please allow LifeSpace to access your location.")
                .multilineTextAlignment(.center)
                .font(.title)
                .padding(10)
            
            if locationFetcher.canShowRequestMessage {
                if locationFetcher.authorizationStatus == .authorizedWhenInUse {

                    Text("Please tap the button below and select \"Change to Always Allow\" on the window that pops up.")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .padding(10)
                    
                    HStack {
                        
                        Spacer()
                        Button(action: {
                            
                            locationFetcher.requestAuthorizationLocation()
                            UserDefaults.standard.set(false, forKey: Constants.JHFirstLocationRequest)
                            locationFetcher.calculateIfCanShowRequestMessage()
                            
                        }, label: {
                             Text("Step Two")
                                .padding(Metrics.PADDING_BUTTON_LABEL)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(self.color)
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .overlay(
                                            RoundedRectangle(cornerRadius: Metrics.RADIUS_CORNER_BUTTON)
                                                .stroke(self.color, lineWidth: 2)
                                    )

                        })
                        .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN)
                        .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN)
                
                        Spacer()
                    }
                    Image("secondTime")
                } else {
                    Text("Please tap the button below and select \"Allow While Using App\" on the window that pops up.")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .padding(10)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            locationFetcher.requestAuthorizationLocation()
                        }, label: {
                             Text("Step One")
                                .padding(Metrics.PADDING_BUTTON_LABEL)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(self.color)
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .overlay(
                                            RoundedRectangle(cornerRadius: Metrics.RADIUS_CORNER_BUTTON)
                                                .stroke(self.color, lineWidth: 2)
                                    )
                        })
                        .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN)
                        .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN)

                        Spacer()
                    }
                }
            } else {
                Text("Please go to location settings and select \"Always\".")
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .padding(10)
                HStack {
                    Spacer()
                    Button(action: {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                         }
                    }, label: {
                        Text("Location Settings")
                            .padding(Metrics.PADDING_BUTTON_LABEL)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(self.color)
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .overlay(
                                        RoundedRectangle(cornerRadius: Metrics.RADIUS_CORNER_BUTTON)
                                            .stroke(self.color, lineWidth: 2)
                                )
                    }).padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN)
                        .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN)

                        Spacer()
                    
                }

            }

            Spacer()
            
        }
    }

}

struct PermissionLocationUIView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionLocationUIView()
    }
}
