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
            Image("CKLogo")
                .resizable()
                .scaledToFit()
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*4)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*4)
            
            Text("To ensure the collection of the information, it is necessary to authorize the use of the location for the application")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18, weight: .bold, design: .default))
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
            
            if locationFetcher.canShowRequestMessage {
                if locationFetcher.authorizationStatus == .authorizedWhenInUse{
                    //Spacer()
                    Text("click on the button and a window will appear where you must select Change to Always Allow.")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                        .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
                    
                    HStack {
                        
                        Spacer()
                        Button(action: {
                            
                            locationFetcher.requestAuthorizationLocation()
                            UserDefaults.standard.set(false, forKey: Constants.JHFirstLocationRequest)
                            locationFetcher.calculeIfCanShowRequestMessage()
                            
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
                }
                else{
                    Text("when you click on the button a window will appear in which you must select Allow While Using App.")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                        .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
                    
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
                    Image("firstTime")
                }
                
            }
            else{
                Text("Please go to the localization settings and select ALWAYS")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*2)
                    .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*2)
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
                        Text("Allow")
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
                    Image("external1")
                    Image("external2")
                
            }
            
//            Text("\(locationFetcher.authorizationStatus.rawValue)")
//
//            if locationFetcher.authorizationStatus != .authorizedWhenInUse && locationFetcher.authorizationStatus != .authorizedAlways{
//
//            }
//            else if (locationFetcher.authorizationStatus == .authorizedWhenInUse){
//
//            }
            Spacer()
            
            Image("SBDLogoGrey")
                .resizable()
                .scaledToFit()
                .padding(.leading, Metrics.PADDING_HORIZONTAL_MAIN*4)
                .padding(.trailing, Metrics.PADDING_HORIZONTAL_MAIN*4)
            
        }
    }
    
}

struct PermissionLocationUIView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionLocationUIView()
    }
}
